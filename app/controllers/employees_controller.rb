class EmployeesController < ApplicationController

	# user must be logged in to get to Employee info
	before_filter :check_login
	load_and_authorize_resource
	
	def index
		if current_user.role == "admin"
			@employees = Employee.alphabetical
		elsif current_user.role == "manager"
			@employees = current_user.employee.current_assignment.store.current_employees
			@store = current_user.employee.current_assignment.store
		end
	end
	
	def show
		@employee = Employee.find(params[:id])
		@user = User.find_by_employee_id(@employee.id)
		authorize! :read, @employee
		@most_recent_assignment = Assignment.for_employee(@employee.id).chronological.last
		@past_assignments = Assignment.for_employee(@employee.id).past.chronological
	end

	def new
		@employee = Employee.new
	end

	def edit
		@employee = Employee.find(params[:id])
	end

	def create
		@employee = Employee.new(params[:employee])
		if @employee.save
			# if saved to database
			flash[:notice] = "Successfully created #{@employee.proper_name}."
			redirect_to @employee # go to show employee page
		else
			# return to the 'new' form
			render :action => 'new'
		end
	end

	def update
		@employee = Employee.find(params[:id])
		if @employee.update_attributes(params[:employee])
			flash[:notice] = "Successfully updated  information for #{@employee.proper_name}."
			redirect_to @employee
		else
			render :action => 'edit'
		end
	end

    def destroy
      @employee = Employee.find(params[:id])
      @employee.destroy
      flash[:notice] = "Successfully removed #{@employee.proper_name} from the system."
      redirect_to employees_url
    end
	
end
