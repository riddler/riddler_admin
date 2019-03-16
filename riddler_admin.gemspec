$:.push File.expand_path("lib", __dir__)

require "riddler_admin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "riddler_admin"
  s.version     = RiddlerAdmin::VERSION
  s.authors     = ["JohnnyT"]
  s.email       = ["ubergeek3141@gmail.com"]
  s.homepage    = "https://github.com/riddler/riddler_admin"
  s.summary     = "Admin Rails engine for Riddler"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2"
  s.add_dependency "riddler", "~> 0.2"
  s.add_dependency "bootstrap"
  s.add_dependency "acts_as_list"
  s.add_dependency "jquery-rails"
  s.add_dependency "jquery-ui-rails"
  s.add_dependency "ulid-ruby"
end
