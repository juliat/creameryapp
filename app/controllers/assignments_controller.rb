class AssignmentsController < ApplicationController
	def index
		@assignments = Assignment.chronological.reverse
	end
	
	def show
		@assignment = Assignment.find(params[:id])
	end

	def new
		@assignment = Assignment.new
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