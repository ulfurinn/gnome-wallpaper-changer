require 'thin'

module Gnome::Wallpaper::Changer
  class Runner

    def initialize argv
      @argv = argv
    end

    def run!

      if @argv.include? "--reset"
        Configuration.reset!
      end

      Configuration.load
      if $stdin.isatty
        puts "The updater is configured using a web interface. Go to http://localhost/#{Configuration.port}"
      end

      EM.next_tick do
        Updater.schedule!
      end

      server = Thin::Server.new '127.0.0.1', Configuration.port do
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
