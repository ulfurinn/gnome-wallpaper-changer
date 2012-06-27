module Gnome::Wallpaper::Changer
  class Updater

    module ClassMethods

      attr_writer :interval

      def schedule!
        @last_timer = EM.add_timer self.interval do
          @last_timer = nil
          self.update
        end
      end

      def update
        puts "update"
        schedule!
      end

      def interval
        @interval ||= 1
      end

    end

    extend ClassMethods

  end
end
