class HomeController < ApplicationController
  def index
	@stores = Store.active.alphabetical;
    @json = Store.all.to_gmaps4rails
  end

  def about
  end

  def contact
  end
  
  def privacy
  end
  
end
