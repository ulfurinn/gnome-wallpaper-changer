require "pathname"

module Gnome::Wallpaper::Changer
  class Updater

    module ClassMethods

      PICTURES = [".jpg", ".png"]

      def schedule!
        @last_timer = EM.add_timer Configuration.interval do
          @last_timer = nil
          self.update if Configuration.active?
        end
      end

      def files
        @files || []
      end

      def update
        @files = get_active_files
        #@files.each { |file| Resizer.resize file }
        if @files.empty?
          `gsettings set org.gnome.desktop.background picture-uri ""`
        else
          selected = @files[ rand(files.length) ]
          puts "update: #{selected}"
          `gsettings set org.gnome.desktop.background picture-uri "file://#{selected}"`
        end
        schedule!
      end

      def get_active_files
        Configuration.folders.map { |folder| get_files_in_folder( folder[:path] ) - folder[:excluded] }.flatten + Configuration.files
      end

      def get_expanded_configuration folder
        if folder
          folder = Configuration.folders.find { |f| f[:path] == folder }
          if folder
            expand_folder_config folder
          else
            nil
          end
        else
          {
            folders: Configuration.folders.map { |folder| self.expand_folder_config folder },
            files: Configuration.files
          }
        end
      end

      def expand_folder_config folder
        folder[:files] = get_files_in_folder(folder[:path])
        folder
      end

      def get_files_in_folder path
        Pathname.new(path).children.select(&:file?).select { |file| PICTURES.include? file.extname }.map(&:to_s)
      end

      def known_file? path
        dir = File.dirname path
        Configuration.files.include?( path ) || Configuration.folders.find { |folder| folder[:path] == dir }
      end

    end

    extend ClassMethods

  end
end
