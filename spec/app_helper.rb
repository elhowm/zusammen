require 'spec_helper'

require File.expand_path('../environment', __dir__)

Dir["#{Ctrl::App::ROOT}/spec/support/**/*.rb"].each do |file|
  require file
end
