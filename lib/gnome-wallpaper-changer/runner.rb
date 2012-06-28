require 'thin'
require 'optparse'

module Gnome::Wallpaper::Changer
  class Runner

    def initialize argv
      @argv = argv
    end

    def run!

      parse_options

      if @options[:reset]
        Configuration.reset!
      end

      if @options[:kill]
        Thin::Server.kill PID_FILE, 0
        FileUtils.rm PID_FILE if File.exists?( PID_FILE )
        exit
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
      
      if @options[:foreground]
        #noop
      elsif @options[:autostart]
        File.open PID_FILE, "w" do |io|
          io.puts Process.pid
        end
        Daemonize.redirect_io LOG_FILE
      else
        server.pid_file = PID_FILE
        server.log_file = LOG_FILE
        server.daemonize
      end
      server.start

    end

    def parse_options
      @options = { }
      OptionParser.new do |opt|
        opt.banner = "Usage: gnome-wallpaper-changer [options]"

        opt.on "-f", "--foreground", "Do not detach from the console" do
          @options[:foreground] = true
        end

        opt.on "-r", "--reset", "Reset the configuration" do
          @options[:reset] = true
        end

        opt.on "-p", "--port N", Integer, "Change and remember the HTTP port", "(default: 12345)" do |port|
          @options[:port] = port
        end

        opt.on "-k", "--kill", "Kill a running instance of the changer and exit" do
          @options[:kill] = true
        end

        opt.on "--autostart", "Internal use" do
          @options[:autostart] = true
        end

        opt.on_tail "-h", "--help", "Prints this message" do
          puts opt
          exit
        end

        opt.on_tail "-v", "--version", "Prints the program version" do
          puts "gnome-wallpaper-changer #{VERSION}"
          exit
        end

      end.parse! @argv
    end

  end
end
