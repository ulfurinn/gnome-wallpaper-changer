require 'thin'

module Gnome::Wallpaper::Changer
  class Runner

    def initialize argv
      @argv = argv
    end

    def run!

      Configuration.load
      if $stdin.isatty
        puts "The updater is configured using a web interface. Go to http://localhost/12345"
      end

      EM.next_tick do
        Updater.schedule!
      end

      server = Thin::Server.new '0.0.0.0', 12345 do
        use Reloader
        run Controller
      end
      #server.pid_file = "updater.pid"
      #server.log_file = "updater.log"
      #server.daemonize
      server.start
    end

  end
end
