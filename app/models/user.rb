class User < ActiveRecord::Base
	
	# Use built-in rails support for password protection
	has_secure_password
	attr_accessible :employee_id, :password, :password_confirmation, :email
	
	# Validations
	# ====================================================================
	# a user must be associated with an employee, have an email, 
	# and have an encoded password
	validates_presence_of :password, :on => :create 
	validates_presence_of :password_confirmation, :on => :create 
	validates_confirmation_of :password, :message => "does not match"
	
	# when created, a user must be connected to an employee who is active in the system
	validate :employee_is_active_in_system, :on => :create
	
	# email must have correct format
	validates_format_of :email, :with => /^[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))$/i, :message => "is not a valid format"
	
	# email must be unique in system
	validates_uniqueness_of :email, :on => :create

	
	# Callbacks
	# ================================================================================
	# Callback to create auth_token for users to enable password_reset
	before_create { generate_token(:auth_token) }


	# Relationships
	# ================================================================================
	belongs_to :employee
		
	
	# Methods
	# ================================================================================
	
	# convenience method to get a user's employee role
	def role
		return self.employee.role
	end
	
	# send a password reset token
	def send_password_reset
	  generate_token(:password_reset_token)
	  self.password_reset_sent_at = Time.zone.now
	  save!
	  UserMailer.password_reset(self).deliver
	end
	
	# Custom Validation Methods
	private
	def employee_is_active_in_system
		all_active_employees = Employee.active.all.map{|e| e.id}
		unless all_active_employees.include?(self.employee_id)
		  errors.add(:employee_id, "is not an active employee at the creamery")
		end
	  end
	
	# authenticate by checking to see if password matches for user w/ given email
	def self.authenticate(email, password)
		find_by_email(email).try(:authenticate, password)
	end

	# generate reset token by using existing database column
	def generate_token(column)
	  begin
		self[column] = SecureRandom.urlsafe_base64
	  end while User.exists?(column => self[column])
	end
	
	
end
