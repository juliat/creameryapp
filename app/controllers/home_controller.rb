class HomeController < ApplicationController
  def index
	@stores = Store.active.alphabetical;
    @json = @stores.to_gmaps4rails do |store, marker|
        marker.title "#{store.name} Store"
    end
  end

<<<<<<< HEAD
  def admin
    @stores = Store.active.alphabetical;
  end
  
  def manager
  end
  
  def employee
  end

=======
>>>>>>> mine/master
  def about
  end

  def contact
  end
  
  def privacy
  end
  
end
