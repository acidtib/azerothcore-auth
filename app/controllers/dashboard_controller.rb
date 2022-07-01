class DashboardController < ApplicationController

	get "/dashboard" do
		redirect_if_not_logged_in
		# redirect_if_not_authorized(user)

		erb :"dashboard"
	end

end