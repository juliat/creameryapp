class HomeController < ApplicationController
  def index
	@stores = Store.active.alphabetical;
    @json = @stores.to_gmaps4rails do |store, marker|
        marker.title "#{store.name} Store"
    end
  end

  def admin
    @stores = Store.active.alphabetical;
  end
  
  def manager
  end
  
  def employee
    @employee = current_user.employee
  end

  def about
  end

  def contact
  end
  
  def privacy
  end
  
end
