# Gnome::Wallpaper::Changer

A utility to periodically rotate the wallpaper in Gnome.

## Installation

    $ gem install gnome-wallpaper-changer

### Prerequisites

* Ruby, properly setup to build native gems
* libgd2

## Usage

The changer runs as a daemon. It has a built-in web server proving the configuration interface.

After installation, run:

	gnome-wallpaper-changer

Then go to http://localhost:12345.
You can override the port using the --port option; this setting will be preserved for future runs.

The wallpaper rotation will be initially disabled; set the interval to a non-zero value to enable.

The changer looks for wallpaper images in several directories; the default ones are /usr/share/backgrounds and ~/Pictures.
You can add or remove them or selectively exclude specific files.

You can set the changer to run automatically at login; this is disabled by default.

To stop the changer, run:

	gnome-wallpaper-changer --kill

## Known issues and limitations

* Chrome sometimes shows incorrect previews, apparently due to its caching strategy.
* Directories are not scanned recursively.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
