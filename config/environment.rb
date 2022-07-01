ENV["SINATRA_ENV"] ||= "development"

require "dotenv/load"
require "bundler/setup"
Bundler.require(:default, ENV["SINATRA_ENV"])


AUTH_DB = ENV["AUTH_DATABASE_URL"]

# set :database, {adapter: "sqlite3", database: "db/#{ENV["SINATRA_ENV"]}.sqlite"}
# set :database_file, "./database.yml"

# require_all "../app"

# require_all "app/controllers"
# require_relative 'app/controllers/application_controller.rb'
require_relative File.join(File.dirname(__FILE__), '../app/controllers/application_controller.rb')
require_relative File.join(File.dirname(__FILE__), '../app/controllers/account_controller.rb')
require_relative File.join(File.dirname(__FILE__), '../app/controllers/dashboard_controller.rb')

require_all File.join(File.dirname(__FILE__), '../app/models')
# require_relative 'app/controllers'

# require_all 'app/controllers/application_controller.rb', 
# 	'app/controllers/account_controller.rb'

# require_relative '../app/controllers/application_controller.rb'
# require_relative '../app/controllers/account_controller.rb'