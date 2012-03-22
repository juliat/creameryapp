Creamery2012::Application.routes.draw do

	# Generated model routes
	  resources :stores
	  resources :employees
	  resources :assignments

	# Semi-static page urls
	match 'home' => 'home#index', :as => :home
end
