module MUI
  class Window_SelectServer < WindowWith4x3Pieces
    def initialize(skin_key: :default_4x3)
      super(x: 60, y: 0, width: 600, height: 800, skin_key: skin_key)
      @label_title.text = "서버 선택"
      @label_title.render

      @button2 = ButtonWithSinglePiece.new(x: 0, y: 0, width: 175, height: 59, skin_key: :one_image)
      @button2.handler_mouse_up = ->(button, x, y) do
        @button2.is_enabled = !@button2.is_enabled
      end
      @button2.z = 1
      add_to_content(control: @button2)

      @button = ButtonWith3x3Pieces.new(x: 20, y: 100, width: 100, height: 32)
      @button.z = 2
      @button.handler_mouse_up = ->(button, x, y) do
        #@button.resize(width: @button.width + 10, height: @button.height)
        #resize(width: @width, height: @height + 5)
        #@button2.is_enabled = !@button2.is_enabled
        @label.resize(width: @label.width + 10, height: @label.height)
      end
      @button.handler_got_focus = ->() do
        #p "got focus"
      end
      @button.handler_lost_focus = ->() do
        #p "lost focus"
      end
      add_to_content(control: @button)

      @label = Label.new(x: 200, y: 20, width: 150, height: 32)
      @label.z = 5
      add_to_content(control: @label)
      @label.render
      
    end

    def has_close_button?
      return true
    end

    def is_disposable?
      return false
    end
  end
end