class User < ActiveRecord::Base
	
	# Callbacks
	# none just yet
	
	
	# Relationships
	belongs_to :employee
	
	
	# Validations
	# a user must be associated with an employee, have an email, and have an encoded password
	validates_presence_of :employee_id, :email, :password_digest
	
	
	# Scopes
	
	
	# Helper Functions
	
end
