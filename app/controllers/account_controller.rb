class AccountController < ApplicationController

	get "/login" do
		# redirect_if_not_logged_in

		if is_logged_in?(session)
			redirect "/dashboard", flash[:message] = "You are already logged in."
		else
			erb :"/account/login"
		end
	end

	post "/login" do
		username = params["username"].strip.upcase
    password = params["password"].strip.upcase

		account = Auth::Account.find_by_username(username)

		if is_logged_in?(session)
			redirect "/dashboard", flash[:message] = "You are already logged in."
		elsif account && verify(account, password)
			session[:user_id] = account.id
      redirect "/dashboard", flash[:message] = "Welcome, #{account.username}!"
		else
			redirect "/login", flash[:message] = "Your credentials are not correct. Please try again."
		end
	end

	get "/signup" do
		if is_logged_in?(session)
			redirect "/dashboard", flash[:message] = "You are already logged in."
		else
			erb :"/account/signup"
		end
	end

	post "/signup" do
		data_params = {}
		data_params[:email] = params[:email].strip
		data_params[:username] = params[:username].strip.upcase

		get_verifier = generate_verifier(data_params[:username], params[:password].strip.upcase)

		data_params[:salt] = get_verifier[:salt]
		data_params[:verifier] = get_verifier[:verifier]

		if is_logged_in?(session)
			redirect "/dashboard", flash[:message] = "You are already logged in."
		elsif params[:email].blank? || params[:username].blank? || params[:password].blank?
			redirect "/signup", flash[:message] = "Please fill out all requested fields to sign up."
		else
			account = Auth::Account.new(data_params)

			if account.save
				session[:user_id] = account.id
				redirect "/dashboard", flash[:message] = "You have successfully created an account. Welcome, #{account.username}."
			else
				redirect "/signup", flash[:message] = "This username or email is taken. Please select another one."
			end
		end
	end

	get "/logout" do
		if is_logged_in?(session)
			session.clear
			redirect "/", flash[:message] = "You have successfully logged out."
		else 
			redirect "/signup"
		end
	end

end