class Auth < ActiveRecord::Base
  self.abstract_class = true

  establish_connection AUTH_DB
end