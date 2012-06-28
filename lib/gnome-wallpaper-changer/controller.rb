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

    post '/include' do
      result = if params[:file]
        Configuration.include_file params[:folder], params[:file]
      else
        Configuration.include_all params[:folder]
      end
      content_type :json
      { result: result }.to_json
    end

    post '/exclude' do
      result = if params[:file]
        Configuration.exclude_file params[:folder], params[:file]
      else
        Configuration.exclude_all params[:folder]
      end
      content_type :json
      { result: result }.to_json
    end

    post '/change' do
      path = params[:file]
      if Updater.known_file? path
        Updater.force_update path
      end
      ""
    end

    get '/wallpapers' do
      content_type :json
      Updater.get_expanded_configuration(params[:folder]).to_json
    end

    get '/file' do
      path = params[:path]
      if Updater.known_file? path
        if thumb = Resizer.resize(path)
          send_file thumb
        else
          500
        end
      else
        403
      end
    end

	end

end
