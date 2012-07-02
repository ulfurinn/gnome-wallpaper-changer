# Gnome::Wallpaper::Changer

A utility to periodically rotate the wallpaper in Gnome.

## Installation

    $ gem install gnome-wallpaper-changer

### Prerequisites

* Ruby 1.9.3, properly setup to build native gems
* libgd2

## Usage

GWChanger runs as a daemon. It has a built-in web server providing the configuration interface.

After installation, run:

	gnome-wallpaper-changer

Then go to http://localhost:12345.
You can override the port using the `--port` option; this setting will be preserved for future runs.

The wallpaper rotation will be initially disabled; set the interval to a non-zero value to enable. Double-click an image to use it immediately.

GWChanger looks for wallpaper images in several directories; the default ones are `/usr/share/backgrounds` and `~/Pictures`.
You can add or remove them or selectively exclude specific files.

You can set GWChanger to run automatically at login; this is disabled by default.

If something goes wrong, you can reset your configuration and start from scratch by running:

	gnome-wallpaper-changer --reset

To stop the daemon, run:

	gnome-wallpaper-changer --kill

## Known issues and limitations

* Chrome sometimes mixes up the image previews, apparently due to its caching strategy.
* Directories are not scanned recursively.

### Ruby managers and autostart

Multiple Ruby managers, such as RVM, heavily modify the environment in order to work. This may prevent the autostarted script from locating the correct Ruby and installed gems. GWChanger will detect RVM and try to generate a wrapper with a fixed environment, but alternative managers are not supported at this point.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Changelog
0.0.2

* Suppressing EPERM on startup when a pid has gone stale.

0.0.1

* Initial release.
