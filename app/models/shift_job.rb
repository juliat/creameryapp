class ShiftJob < ActiveRecord::Base
	
	# Callbacks
	# none just yet
	
	
	# Relationships
	belongs_to :shifts
	belongs_to :jobs
	
	
	# Validations
	validates_presence_of :shift_id, :job_id
	
	# Scopes
	
	
	# Helper Functions
	
end
