require "sinatra/base"
require "json"

module Gnome::Wallpaper::Changer

	class Controller < Sinatra::Base

    def self.main_file
      __FILE__
    end

    def sanitize_path folder
      if folder.empty?
        return nil
      end

      folder_pn = Pathname.new folder

      if folder_pn.relative?
        return nil
      end

      folder_pn = folder_pn.expand_path

      if !folder_pn.exist?
        return nil
      end

      folder_pn.to_s
    end

    set :root, File.join(File.dirname(main_file), "..", "..")
    set :haml, :format => :html5

    get '/' do
      haml :index
    end

    get '/autostart' do
      content_type :json
      { enabled: Configuration.autostart_installed? }.to_json
    end

    post '/autostart' do
      if params[:enable] == "true"
        Configuration.install_autostart!
      else
        Configuration.uninstall_autostart!
      end
      content_type :json
      { enabled: Configuration.autostart_installed? }.to_json
    end

    get '/interval' do
      content_type :json
      { interval: Configuration.active? ? Configuration.interval / 60 : 0 }.to_json
    end

    post '/interval' do
      interval = params[:interval].to_i
      if interval > 0
        Configuration.active = true
        Configuration.interval = interval * 60 rescue nil
      else
        Configuration.active = false
      end
      Updater.reschedule!
      
      content_type :json
      { interval: Configuration.active? ? Configuration.interval / 60 : 0 }.to_json
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

    post '/add' do

      folder = sanitize_path params[:folder]
      return nil.to_json if folder.nil?

      result = Configuration.add_folder folder
      content_type :json
      if result
        Updater.get_expanded_configuration(params[:folder])
      else
        nil
      end.to_json
    end

    post '/remove' do
      Configuration.remove_folder params[:folder]
      ''
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

    get '/folder-suggest' do
      term = params[:term]
      lookup_dir = term.gsub /[^\/]+$/, ""
      partial = term[ ( term.rindex('/') + 1 )..-1 ]
      Pathname.new(lookup_dir).children.select { |child| child.directory? && child.basename.to_s.index( partial ) == 0 }.map(&:to_s).sort.to_json
    end

	end

end
