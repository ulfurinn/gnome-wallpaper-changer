require "fileutils"
require "yaml"

module Gnome::Wallpaper::Changer
  class Configuration

    module ClassMethods

      attr_accessor :interval

      CONFIG_DIR = "#{ENV['HOME']}/.config/gnome-wallpaper-changer"
      CONFIG_FILE = "#{CONFIG_DIR}/config.yml"

      def interval
        @interval ||= 60 * 10
      end

      def default_config
        {
          interval: 60 * 10
        }
      end

      def current_config
        {
          version: VERSION,
          interval: self.interval
        }
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

        self.interval = config[:interval]

        save unless File.exists?( CONFIG_FILE )

      end

      def save
        File.open CONFIG_FILE, "w" do |io|
          io.write current_config.to_yaml
        end
      end

    end

    extend ClassMethods

  end
end
