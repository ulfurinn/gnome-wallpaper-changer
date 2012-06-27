require 'digest/sha1'
require 'fastimage_resize'

module Gnome::Wallpaper::Changer
  class Resizer

    module ClassMethods

      THUMB_DIR = "#{ENV['HOME']}/.config/gnome-wallpaper-changer/thumbs"

      def resize path
        thumb = Digest::SHA1.hexdigest(path) + File.extname(path)
        thumb_path = THUMB_DIR + '/' + thumb
        if !File.exists?( thumb_path )
          File.open path, "r" do |io|
            FastImage.resize io, 0, 50, :outfile => thumb_path
          end
        end
        thumb_path
      rescue FastImage::ImageFetchFailure => e
        puts "Could not open file: #{path} (#{e})"
        nil
      end

    end

    extend ClassMethods

    FileUtils.mkdir_p( ClassMethods::THUMB_DIR )

  end
end
