require "yaml"

module Gnome::Wallpaper::Changer
  class Configuration

    module ClassMethods

      private

      def self.autosaving *attrs
        attrs.each do |attribute|

          define_method "autosaving_#{attribute}_set".to_sym do |value|
            self.send "real_#{attribute}_set".to_sym, value
            self.save!
          end

          alias_method "real_#{attribute}_set".to_sym, "#{attribute}=".to_sym
          alias_method "#{attribute}=".to_sym, "autosaving_#{attribute}_set".to_sym

        end
      end

      public

      attr_accessor :interval, :port, :active, :folders, :files

      def interval= value
        @interval = if value < 60
          60
        else
          value
        end
      end

      autosaving :interval, :port, :active, :folders, :files
      alias_method :active?, :active

      def default_config
        {
          interval: 60 * 10,
          port: 12345,
          active: false,
          folders: [ {
              path: ENV['HOME'] + '/Pictures',
              excluded: []
            }, {
              path: '/usr/share/backgrounds',
              excluded: []
            }
          ],
          files: [ ]
        }
      end

      def current_config
        {
          version: VERSION,
          port: self.port,
          interval: self.interval,
          active: self.active?,
          folders: self.folders,
          files: self.files
        }
      end

      def reset!
        if File.exists?( CONFIG_FILE )
          FileUtils.rm CONFIG_FILE
        end
      end

      def load
        
        unless Dir.exists?( CONFIG_DIR )
          FileUtils.mkdir_p CONFIG_DIR
        end

        config = if File.exists?( CONFIG_FILE )
          YAML.load File.read( CONFIG_FILE )
        else
          default_config
        end

        default_config.keys.each do |key|
          self.send "#{key}=".to_sym, config[key]
        end

        save unless File.exists?( CONFIG_FILE )

      end

      def save!
        File.open CONFIG_FILE, "w" do |io|
          io.write current_config.to_yaml
        end
      end

      def include_file folder, file
        # => basic sanity check...
        if File.dirname(file) == folder
          folder = folders.find { |f| f[:path] == folder }
          return false unless folder
          folder[:excluded].delete file
          save!
          true
        else
          false
        end
      end

      def include_all folder
        folder = folders.find { |f| f[:path] == folder }
        if folder
          folder[:excluded] = []
          save!
          true
        else
          false
        end
      end

      def exclude_file folder, file
        # => basic sanity check...
        if File.dirname(file) == folder
          folder = folders.find { |f| f[:path] == folder }
          return false unless folder
          folder[:excluded] << file unless folder[:excluded].include?( file )
          save!
          true
        else
          false
        end
      end

      def exclude_all folder
        folder = folders.find { |f| f[:path] == folder }
        if folder
          folder[:excluded] = Updater.get_files_in_folder folder[:path]
          save!
          true
        else
          false
        end
      end

      def add_folder folder
        if folders.find{ |f| f[:path] == folder }
          false
        else
          folders << { path: folder, excluded: [] }
          save!
          true
        end
      end

      def remove_folder folder
        folders.reject! { |f| f[:path] == folder }
        save!
      end

      def install_autostart!
        bin = Gem.bin_path "gnome-wallpaper-changer", "gnome-wallpaper-changer"
        File.open AUTOSTART, "w" do |io|
          io.puts "[Desktop Entry]"
          io.puts "Type=Application"
          io.puts "Terminal=false"
          io.puts "Name=Wallpaper Changer"
          io.puts "Comment=Periodically changes the Gnome wallpaper"
          io.puts "Exec=#{bin} --autostart"
        end
      rescue Gem::GemNotFoundException => e
        puts "Cannot activate autostart with a development version"
      end

      def uninstall_autostart!
        FileUtils.rm AUTOSTART if autostart_installed?
      end

      def autostart_installed?
        File.exists? AUTOSTART
      end

    end

    extend ClassMethods

  end
end
