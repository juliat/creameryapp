class Job < ActiveRecord::Base
		
	# Validations
	# ====================================================================
	validates_presence_of :name
	 
	 	
	# Relationships
	# ====================================================================
	has_many :shift_jobs
	has_many :shifts, :through => :shift_jobs
	
	# Scopes
	# ====================================================================
	# active: returns only active jobs
	scope :active, where("active = ?", true)
	
	# inactive: returns all inactive jobs
	scope :inactive, where("active = ?", false)
	
	# alphabetically: returns a list of all jobs ordered alphabetically by name
	scope :alphabetical, order("name")
	
end
