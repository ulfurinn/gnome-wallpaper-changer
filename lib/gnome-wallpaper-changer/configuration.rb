require "fileutils"
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

      attr_accessor :interval, :port
      autosaving :interval, :port

      CONFIG_DIR = "#{ENV['HOME']}/.config/gnome-wallpaper-changer"
      CONFIG_FILE = "#{CONFIG_DIR}/config.yml"

      def default_config
        {
          interval: 60 * 10,
          port: 12345
        }
      end

      def current_config
        {
          version: VERSION,
          port: self.port,
          interval: self.interval
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

      def install_autostart!

      end

      def uninstall_autostart!

      end

      def autostart_installed?

      end

    end

    extend ClassMethods

  end
end