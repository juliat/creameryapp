class Jobs < ActiveRecord::Base
	
	# Callbacks
	# none just yet
	
	
	# Relationships
	has_many :shiftjobs
	
	
	# Validations
	validates_presence_of :name
	
	# Scopes
	
	
	# Helper Functions
	
end
