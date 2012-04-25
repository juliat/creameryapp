class User < ActiveRecord::Base
	
	attr_accessible :email, :employee_id, :password, :password_confirmation
	
	# use rails built-in password management
	has_secure_password

	# Relationships
	# ====================================================================
	belongs_to :employee
	
		
	# Scopes
	# ====================================================================
	# none right now
	
	
	# Validations
	# ====================================================================
	# a user must be associated with an employee, have an email, and have an encoded password
	validates_presence_of :password_digest
	
	# when created, a user must be connected to an employee who is active in the system
	validate :employee_is_active_in_system, :on => :create
	
	# email must have correct format
	# [letters, digits, underscore, plus, dot]@[letters, digits].[two to four letters/digits] 
	# (case insensitive)
	validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
	
	# email must be unique in system
	validates_uniqueness_of :email
	
	
	# Custom Validation Methods
	private
	def employee_is_active_in_system
		active_employees = Employee.active.map{|employee| employee.id}
		return active_employees.include?(self.employee_id)
	end
	
	def self.authenticate(email, password)
		find_by_email(email).try(:authenticate, password)
	end
	
	
end
