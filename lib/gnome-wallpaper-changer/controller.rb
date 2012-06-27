require "sinatra/base"
require "json"

module Gnome::Wallpaper::Changer

	class Controller < Sinatra::Base

    def self.main_file
      __FILE__
    end

    set :root, File.join(File.dirname(main_file), "..", "..")
    set :haml, :format => :html5

    get '/' do
      haml :index
    end

    get '/interval' do
      content_type :json
      { interval: Configuration.interval / 60 }.to_json
    end

    post '/interval' do
      Configuration.interval = params[:interval].to_i * 60 rescue nil
      content_type :json
      { interval: Configuration.interval / 60 }.to_json
    end

    get '/wallpapers' do
      content_type :json
      Updater.get_expanded_configuration.to_json
    end

	end

end
