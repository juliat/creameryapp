class HomeController < ApplicationController
  def index
    if logged_in?
        if current_user.role == "admin"
            @stores = Store.active.alphabetical;
            # @top_employees = Employee.by_hours;
        elsif current_user.role == "manager"
            
        end
    else
        @stores = Store.active.alphabetical;
        @json = @stores.to_gmaps4rails do |store, marker|
            marker.title "#{store.name} Store"
        end
    end
  end

  def about
  end

  def contact
  end
  
  def privacy
  end
  
end
