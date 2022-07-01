require "./config/environment.rb"

# require_all "app"

# if ActiveRecord::Base.connection.migration_context.needs_migration?
#   raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
# end

# use Rack::MethodOverride
# use ApplicationController
# use BooksController
use AccountController
use DashboardController
run ApplicationController