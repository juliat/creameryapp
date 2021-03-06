class JobsController < ApplicationController

	# user must be logged in to get to Job info
	before_filter :check_login
	authorize_resource

	def index
		@jobs = Job.alphabetical
	end
	
	def show
		@job = Job.find(params[:id])
	end

	def new
		@job = Job.new
	end

	def edit
		@job = Job.find(params[:id])
	end

	def create
		@job = Job.new(params[:job])
		if @job.save
			# if saved to database
			flash[:notice] = "Successfully created #{@job.name}."
			redirect_to @job
		else
			# return to the 'new' form
			render :action => 'new'
		end
	end

	def update
		@job = Job.find(params[:id])
		if @job.update_attributes(params[:job])
			flash[:notice] = "Successfully updated information for #{@job.name}."
			redirect_to @job
		else
			render :action => 'edit'
		end
	end

    def destroy
      @job = Job.find(params[:id])
      @job.destroy
      flash[:notice] = "Successfully removed #{@job.name} from the system."
      redirect_to jobs_url
    end
	
end
