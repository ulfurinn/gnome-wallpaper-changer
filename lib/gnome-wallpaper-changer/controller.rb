require "sinatra/base"

module Gnome::Wallpaper::Changer

	class Controller < Sinatra::Base

    def self.main_file
      __FILE__
    end

    get '/' do
      "wallpaper changer"
    end

    get '/interval/:interval' do
      Configuration.interval = params[:interval].to_i rescue nil
      Configuration.save
      "interval set to #{Configuration.interval} seconds"
    end

	end

end
