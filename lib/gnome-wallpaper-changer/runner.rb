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
        puts "Go to http://localhost:#{Configuration.port} to change the settings."
      end

      EM.next_tick do
        if Configuration.active?
          Updater.update
        end
      end

      server = Thin::Server.new '127.0.0.1', Configuration.port do
        use Rack::CommonLogger
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
