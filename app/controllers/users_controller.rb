class UsersController < ApplicationController

	# everyone can run new and create actions, but only those actions
	before_filter :check_login, :except => [:new, :create]
	authorize_resource

	def index
		@users = User.all
	end
	
	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
		@user.employee_id = params[:employee_id] unless params[:employee_id].nil?
	end
	
	def edit
		@user = User.find(params[:id])
	end
	
	def create
		@user = User.new(params[:user])
		if @user.save
			# provide email confirmation if all is good
			UserMailer.new_user_message(@user).deliver
			# and confirm that this was done
			redirect_to(@user.employee, :notice => "#{@user.employee.proper_name} has been registered as a user and recieved a password via email.")
		  
		else
			render :action => "new"
		end
	end
	
	def update
		# get current user from current_user method
		@user = current_user
		if @user.update_attributes(params[:user])
		  # when a new user is saved, add the user_id to the session hash
		  # session[:user_id] = @user.id	
		  redirect_to(home_path, :notice => 'User was successfully updated.')
		else
		  render :action => "edit"
		end	
	end
end
