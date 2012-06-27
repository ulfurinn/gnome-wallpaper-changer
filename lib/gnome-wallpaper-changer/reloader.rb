require "rack/reloader"

module Gnome::Wallpaper::Changer

  class Reloader < Rack::Reloader

    def safe_load file, mtime, stderr = $stderr
      if file == Controller.main_file 
        Controller.reset! 
      end 
      super 
    end 

  end

end
