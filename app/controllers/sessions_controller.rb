class SessionsController < ApplicationController
	def new
	end
	
	# tries to authenticate and if sucessfull sets the user id in session
	def create
		user = User.find_by_email(params[:email])
		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect_to home_path, notice: "Logged in!"
		else
			flash.now.alert = "Email or password is invalid"
			render "new"
		end
	end
	
	# for logout, destroys the user_is in session
	def destroy
		session[:user_id] = nil
		redirect_to home_path, notice: "Logged out!"
	end
		
end
