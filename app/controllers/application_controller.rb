require "./config/environment"
require "sinatra/base"
require "sinatra/reloader"
require "sinatra/flash"

require "pp"

module Helpers
	def is_logged_in?(session)
		!!session[:user_id]
	end

	def current_user
		@current_user ||= Auth::Account.find(session[:user_id])
	end

	def redirect_if_not_logged_in
		if !is_logged_in?(session)
			redirect "/login", flash[:message] = "You must be logged in."
		end
	end

	def redirect_if_user_not_authorized(user)
		if user != current_user
			redirect "/login", flash[:message] = "There was an error. Please try again."
		end
	end

	# <%= partial(:template, :post => post) %>
	def partial(template, locals = {})
		erb(template, :layout => false, :locals => locals)
	end

	def verify(account, password)
		h1 = Digest::SHA1.digest("#{account.username}:#{password}")
		h2 = Digest::SHA1.digest(account.salt + h1)

		h2_int = h2.reverse.unpack("H*").first.to_i(16)

		g = 7
		n = 0x894B645E89E1535BBDAD5B8B290650530801B18EBFBF5E8FAB3C82872A3E9BB7

		verifier_int = g.pow(h2_int, n)
		verifier = [verifier_int.to_s(16)].pack('H*').reverse

		verifier == account.verifier
	end

	def generate_verifier(username, password)
		salt = SecureRandom.random_bytes(32)
		h1 = Digest::SHA1.digest("#{username}:#{password}")
		h2 = Digest::SHA1.digest(salt + h1)

		h2_int = h2.reverse.unpack("H*").first.to_i(16)

		g = 7
		n = 0x894B645E89E1535BBDAD5B8B290650530801B18EBFBF5E8FAB3C82872A3E9BB7

		verifier_int = g.pow(h2_int, n)
		verifier = [verifier_int.to_s(16)].pack('H*').reverse

		{salt: salt, verifier: verifier}
	end
end

class ApplicationController < Sinatra::Base
	configure do
		enable :sessions
		set :public_folder, "public"
		set :session_secret, ENV["SESSION_SECRET"]
		set :views, "app/views"
		register Sinatra::Flash
		register Sinatra::Reloader
	end

	get "/" do
		# realms = Auth::Realmlist.all

		# pp realms

		erb :index
	end

	helpers Helpers
end