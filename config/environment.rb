ENV["SINATRA_ENV"] ||= "development"

require "dotenv/load"
require "bundler/setup"
Bundler.require(:default, ENV["SINATRA_ENV"])


AUTH_DB = ENV["AUTH_DATABASE_URL"]

require_relative File.join(File.dirname(__FILE__), '../app/controllers/application_controller.rb')
require_relative File.join(File.dirname(__FILE__), '../app/controllers/account_controller.rb')
require_relative File.join(File.dirname(__FILE__), '../app/controllers/dashboard_controller.rb')

require_all File.join(File.dirname(__FILE__), '../app/models')