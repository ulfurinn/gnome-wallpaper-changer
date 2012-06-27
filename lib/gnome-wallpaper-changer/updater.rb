module Gnome::Wallpaper::Changer
  class Updater

    module ClassMethods

      def schedule!
        @last_timer = EM.add_timer Configuration.interval do
          @last_timer = nil
          self.update
        end
      end

      def update
        puts "update"
        schedule!
      end

    end

    extend ClassMethods

  end
end
