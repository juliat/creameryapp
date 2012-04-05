class Shifts < ActiveRecord::Base
	
	# Callbacks
	# none just yet
	
	
	# Relationships
	has_many :jobs, :through => :shiftjobs
	belongs_to :assignment
	has_one :store, :through => :assignment
	has_one :employee, :through => :assignment
	
	
	# Validations
	
	
	# Scopes
	
	
	# Helper Functions
	
end
