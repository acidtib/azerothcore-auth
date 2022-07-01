class Auth::Uptime < Auth
	self.table_name = "uptime"
  self.primary_key = "realmid"
end