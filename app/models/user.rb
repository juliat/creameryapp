class User < ActiveRecord::Base
	
	# Callbacks
	# none just yet
	
	
	# Relationships
	belongs_to :employee
	
	
	# Validations
	validates_presence_of :employee_id, :email, :password_digest
	
	
	# Scopes
	
	
	# Helper Functions
	
end
