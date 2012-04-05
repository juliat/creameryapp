class Shifts < ActiveRecord::Base
	
	# Callbacks
	# none just yet
	
	
	# Relationships
	belongs_to :assignment
	has_many :jobs, 
	
	
	# Validations
	
	
	# Scopes
	
	
	# Helper Functions
	
end
