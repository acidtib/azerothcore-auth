module Dashboard
	class SettingsController < DashboardController

		get "/account/settings" do
			redirect_if_not_logged_in
	
			erb :"/dashboard/account/settings"
		end

		post "/account/settings/:id" do
			redirect_if_not_logged_in

			data_params = {}

			data_params[:email] = params[:email].strip
			data_params[:username] = params[:username].strip.upcase

			account = Auth::Account.find(params[:id])

			redirect_if_user_not_authorized(account)
			
			if Auth::Account.where.not(id: account.id).where(email: data_params[:email]).empty? == false
				redirect "/account/settings", flash[:message] = "Email has already been taken. Please try again."
			end

			if Auth::Account.where.not(id: account.id).where(username: data_params[:username]).empty? == false
				redirect "/account/settings", flash[:message] = "Username has already been taken. Please try again."
			end

			if account.update(data_params)
				redirect "/account/settings", flash[:message] = "You have successfully updated your account."
			else
				redirect "/account/settings", flash[:message] = "There was an error updating your account. Please try again."
			end
		end

		get "/account/settings/security" do
			redirect_if_not_logged_in
	
			erb :"/dashboard/account/security"
		end

		post "/account/settings/security/:id" do
			redirect_if_not_logged_in

			data_params = {}
			current_password = params[:current_password].strip.upcase
			new_password = params[:new_password].strip.upcase
			confirm_new_password = params[:confirm_new_password].strip.upcase

			account = Auth::Account.find(params[:id])

			redirect_if_user_not_authorized(account)

			# do we have values
			if current_password.blank? || new_password.blank? || confirm_new_password.blank?
				redirect "/account/settings/security", flash[:message] = "All fields must be filled out."
			end

			# does the new password match
			if new_password != confirm_new_password
				redirect "/account/settings/security", flash[:message] = "The new password does not match."
			end

			if verify(account, current_password) == false
				redirect "/account/settings/security", flash[:message] = "The current password is wrong."
			end


			get_verifier = generate_verifier(account.username, new_password)

			data_params[:salt] = get_verifier[:salt]
			data_params[:verifier] = get_verifier[:verifier]

			if account.update(data_params)
				redirect "/account/settings/security", flash[:message] = "You have successfully updated your security."
			else
				redirect "/account/settings/security", flash[:message] = "There was an error updating your security. Please try again."
			end

		end
	
	end
end