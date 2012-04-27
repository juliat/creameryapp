class HomeController < ApplicationController
  def index
    if logged_in?
        if current_user.role == "admin"
            @stores = Store.active.alphabetical;
            @top_employees = Employee.top_employees;
        elsif current_user.role == "manager"
            @store = current_user.employee.current_assignment.store
        elsif current_user.role == "employee"
            @employee = current_user.employee
            unless  @employee.current_assignment.nil?
                @shifts =@employee.current_assignment.shifts
            end
        end
    else
        @stores = Store.active.alphabetical;
        @json = @stores.to_gmaps4rails do |store, marker|
            marker.title "#{store.name} Store"
        end
    end
  end

  def search
    @query = params[:query]
    @employees = Employee.search(@query)
    @total_hits = @employees.size
  end

  def about
  end

  def contact
  end
  
  def privacy
  end
  
end
