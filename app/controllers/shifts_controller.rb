class ShiftsController < ApplicationController
	
	# user must be logged in to get to shift info
	before_filter :check_login
	load_and_authorize_resource
	
	include ApplicationHelper
	
	def index
		@shifts = Shift.chronological
	end
	
	def show
		@shift = Shift.find(params[:id])
	end

	def new
		@shift = Shift.new
	end

	def edit
		@shift = Shift.find(params[:id])
		@shift.date = humanize_date(@shift.date)
	end

	def create
		@shift = Shift.new(params[:shift])
		@shift.date = Chronic.parse(params[:shift][:date])
		if @shift.save
			# if saved to database
			flash[:notice] = "Successfully created this shift."
			redirect_to @shift # go to show shift page
		else
			# return to the 'new' form
			render :action => 'new'
		end
	end

	def update
		@shift = Shift.find(params[:id])
		@shift.date = Chronic.parse(params[:shift][:date])
		if @shift.update_attributes(params[:shift])
			flash[:notice] = "Successfully updated this shift."
			redirect_to @shift
		else
			render :action => 'edit'
		end
	end

    def destroy
      @shift = Shift.find(params[:id])
      @shift.destroy
      flash[:notice] = "Successfully removed this shift from the system."
      redirect_to shifts_url
    end
	
end
