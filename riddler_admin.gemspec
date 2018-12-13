$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
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

  s.add_dependency "rails", "~> 5.2.1"
  s.add_dependency "bootstrap", "~> 4.1.3"
  s.add_dependency "ksuid"
  s.add_dependency "acts_as_list"
  s.add_dependency "jquery-rails"
  s.add_dependency "jquery-ui-rails"

  s.add_development_dependency "sqlite3"
end
