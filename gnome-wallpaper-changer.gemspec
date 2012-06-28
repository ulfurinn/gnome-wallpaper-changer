# -*- encoding: utf-8 -*-
require File.expand_path('../lib/gnome-wallpaper-changer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Valeri Sokolov"]
  gem.email         = ["ulfurinn@ulfurinn.net"]
  gem.description   = %q{A wallpaper rotation daemon with a browser-based interface.}
  gem.summary       = %q{A wallpaper rotation daemon with a browser-based interface.}
  gem.homepage      = "https://github.com/ulfurinn/gnome-wallpaper-changer"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "gnome-wallpaper-changer"
  gem.require_paths = ["lib"]
  gem.version       = Gnome::Wallpaper::Changer::VERSION

  gem.add_dependency "thin"
  gem.add_dependency "sinatra"
  gem.add_dependency "haml"
  gem.add_dependency "json"
  gem.add_dependency "fastimage_resize"
end
