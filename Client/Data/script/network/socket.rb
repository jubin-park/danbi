# encoding: utf-8

#===============================================================================
# ** Socket
#-------------------------------------------------------------------------------
# Author    Lee SangHyuk
# Date      2013. 1. 8 *
#===============================================================================

class Socket
  attr_reader :pdata
  attr_reader :IsConnected
  
  def self.init
    @pdata = ""
    @isConnected = false
  end
  
  def self.connect(ip, port)
    Network.connect(ip, port)
    @isConnected = true
  end  
  
  def self.send(data)
    return if not @isConnected
    json_data = JSON.encode(data)
    
    msg = "\0" * (json_data.size + 8)
    msg[0] = [json_data.size >> 24 & 0xff].pack('U*')
    msg[1] = [json_data.size >> 16 & 0xff].pack('U*')
    msg[2] = [json_data.size >>  8 & 0xff].pack('U*')
    msg[3] = [json_data.size       & 0xff].pack('U*')
    for i in 0...json_data.size
      msg[4+i] = json_data[i]
    end
    msg += "\n"

    p "data #{data}"
    p "json_data #{json_data}"
    p "msg #{msg}"

    Network.send(msg)
  end
  
  def self.close
    Network.close
  end
  
  def self.update
    return if not @isConnected
    if Network.ready?
      temp, plen = Network.recv(0xffff)
      @pdata << temp[0...plen].delete("\0")
    end
    while @pdata.size > 2
      sIndex = 0
      eIndex = 0
      for i in 0...@pdata.size
        if @pdata[i] == "{"
          sIndex = i
        elsif @pdata[i] == "}"
          eIndex = i
          break
        end
      end
      if sIndex < eIndex
        data = @pdata[sIndex..eIndex]
        Packet.receive(JSON.decode(data))
      end
      @pdata = @pdata[(eIndex + (eIndex == 0 ? 0 : 1))...@pdata.size]
    end
  end
end