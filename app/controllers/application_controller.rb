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
		Auth::Account.find(session[:user_id])
	end

	def redirect_if_not_logged_in
		if !is_logged_in?(session)
			redirect "/login", flash[:message] = "You must be logged in."
		end
	end

	def redirect_if_not_authorized(user)
		if user != current_user
			redirect "/login", flash[:message] = "There was an error. Please try again."
		end
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
		realms = Auth::Realmlist.all

		# pp realms

		erb :index
	end

	helpers Helpers
end