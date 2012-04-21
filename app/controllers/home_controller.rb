class HomeController < ApplicationController
  def index
	@stores = Store.active.alphabetical;
    @json = @stores.to_gmaps4rails do |store, marker|
        marker.title "#{store.name} Store"
    end
  end

  def about
  end

  def contact
  end
  
  def privacy
  end
  
end
