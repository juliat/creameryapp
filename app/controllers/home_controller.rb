class HomeController < ApplicationController

  def index
    if logged_in?
        if current_user.role == "admin"
            @stores = Store.active.alphabetical;
            @top_employees = Employee.top_employees;
        elsif current_user.role == "manager"
            @manager = current_user.employee
            unless @manager.current_assignment.nil?
                @store = current_user.employee.current_assignment.store
            else
                @store = nil
            end
        elsif current_user.role == "employee"
            @employee = current_user.employee
            unless  @employee.current_assignment.nil?
                @shifts =@employee.current_assignment.shifts
            end
        end
        @main_html_id = "dash";
    else
        @stores = Store.active.alphabetical;
        #~ @json = Store.all.to_gmaps4rails do |store, marker|
          #~ marker.infowindow render_to_string(:partial => "/users/my_template", :locals => { :object => user})
          #~ marker.picture({
                          #~ :picture => "http://www.blankdots.com/img/github-32x32.png",
                          #~ :width   => 32,
                          #~ :height  => 32
                         #~ })
          #~ marker.title   "i'm the title"
          #~ marker.sidebar "i'm the sidebar"
          #~ marker.json({ :id => store.id, :foo => "bar" })
        #~ end
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
