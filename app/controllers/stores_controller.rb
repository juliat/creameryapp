class StoresController < ApplicationController
	def index
		@stores = Store.active.alphabetical
	end
	
	def show
		@store = Store.find(params[:id])
		@current_employees = Assignment.current.for_store(@store.id).map!{|a| a.employee}
		# @past_employees = Assignment.past.for_store(@store.id).map!{|a| a.employee} 
		@json = Store.all.to_gmaps4rails
	end

	def new
		@store = Store.new
	end

	def edit
		@store = Store.find(params[:id])
	end

	def create
		@store = Store.new(params[:store])
		if @store.save
			# if saved to database
			flash[:notice] = "Successfully created #{@store.name}."
			redirect_to @store # go to show store page
		else
			# return to the 'new' form
			render :action => 'new'
		end
	end

	def update
		@store = Store.find(params[:id])
		if @store.update_attributes(params[:store])
			flash[:notice] = "Successfully updated #{@store.name}."
			redirect_to @store
		else
			render :action => 'edit'
		end
	end

    def destroy
      @store = Store.find(params[:id])
      @store.destroy
      flash[:notice] = "Successfully removed #{@store.name} from the system."
      redirect_to stores_url
    end
	
end
