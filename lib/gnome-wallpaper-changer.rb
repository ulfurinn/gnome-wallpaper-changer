require "fileutils"

module Gnome
  module Wallpaper
    module Changer
      
      CONFIG_DIR = "#{ENV['HOME']}/.config/gnome-wallpaper-changer"

      CONFIG_FILE = "#{CONFIG_DIR}/config.yml"
      THUMB_DIR = "#{CONFIG_DIR}/thumbs"

      PID_FILE = "#{CONFIG_DIR}/updater.pid"
      LOG_FILE = "#{CONFIG_DIR}/updater.log"

      AUTOSTART_DIR = "#{ENV['HOME']}/.config/autostart"
      AUTOSTART = "#{AUTOSTART_DIR}/gnome-wallpaper-changer.desktop"

    end
  end
end

require "gnome-wallpaper-changer/version"
require "gnome-wallpaper-changer/reloader"
require "gnome-wallpaper-changer/configuration"
require "gnome-wallpaper-changer/controller"
require "gnome-wallpaper-changer/updater"
require "gnome-wallpaper-changer/resizer"
require "gnome-wallpaper-changer/runner"
