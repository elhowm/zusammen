# Ruby dependencies
require 'singleton'
require 'forwardable'

# Gem dependencies
require 'rubygems'
require 'bundler'

APP_ENV = ENV.fetch('ENV') { 'development' }
groups = [:default]
groups << :development if APP_ENV == 'development'
Bundler.require(*groups)

# Application dependencies
require_relative 'app'
require_relative 'app/mixins'
require_relative 'app/interactors'
require_relative 'app/models'
require_relative 'app/repos'

I18n.load_path << Dir["#{Ctrl::App::ROOT}/locales/**/*.yml"]
I18n.default_locale = :en
