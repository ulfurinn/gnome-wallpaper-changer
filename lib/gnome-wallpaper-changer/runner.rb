require 'thin'

module Gnome::Wallpaper::Changer
  class Runner

    def initialize argv
      @argv = argv
    end

    def run!
      Thin::Server.start '0.0.0.0', 12345 do
        p env
        use Gnome::Wallpaper::Changer::Reloader
        run Gnome::Wallpaper::Changer::Controller
      end
    end

  end
end
