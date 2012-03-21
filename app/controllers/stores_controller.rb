class StoresController < ApplicationController
	def index
		@stores = Store.active.alphabetical
	end
end