class HomeController < ApplicationController
  def index
	@stores = Store.active.alphabetical;
  end

  def about
  end

  def contact
  end
  
  def privacy
  end
  
end