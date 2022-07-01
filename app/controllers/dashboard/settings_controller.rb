module Dashboard
	class SettingsController < DashboardController

		get "/account/settings" do
			redirect_if_not_logged_in
	
			erb :"/dashboard/account/settings"
		end
	
	end
end