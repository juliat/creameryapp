class AssignmentsController < ApplicationController
	
	# everyone can run new and create actions, but only those actions
	before_filter :check_login
	authorize_resource
	
	def index
		@current_assignments = Assignment.current.chronological.reverse
		@past_assignments = Assignment.past.chronological.reverse
	end
	
	def show
		@assignment = Assignment.find(params[:id])
	end

	def new
		@assignment = Assignment.new
		@assignment.store_id = params[:store_id] unless params[:store_id].nil?
	end

	def edit
		@assignment = Assignment.find(params[:id])
	end

	def create
		@assignment = Assignment.new(params[:assignment])
		if @assignment.save
			# if saved to database
			flash[:notice] = "Successfully created assignment for #{@assignment.employee.proper_name} to the #{@assignment.store.name} store."
			redirect_to @assignment # go to show assignment page
		else
			# return to the 'new' form
			render :action => 'new'
		end
	end

	def update
		@assignment = Assignment.find(params[:id])
		if @assignment.update_attributes(params[:assignment])
			flash[:notice] = "Successfully updated assignment for #{@assignment.employee.proper_name} to the #{@assignment.store.name} store."
			redirect_to @assignment
		else
			render :action => 'edit'
		end
	end

    def destroy
      @assignment = Assignment.find(params[:id])
      @assignment.destroy
      flash[:notice] = "Successfully removed assignment for #{@assignment.employee.proper_name} to the #{@assignment.store.name} store from the system."
      redirect_to assignments_url
    end
	
end
