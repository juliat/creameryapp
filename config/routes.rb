Creamery2012::Application.routes.draw do
	match 'home' => 'home#index', :as => :home
end
