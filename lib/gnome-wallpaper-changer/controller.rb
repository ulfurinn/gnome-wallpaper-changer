require "sinatra/base"

module Gnome::Wallpaper::Changer

	class Controller < Sinatra::Base

    def self.main_file
      __FILE__
    end

    get '/' do
      "wallpaper changer"
    end

	end

end
