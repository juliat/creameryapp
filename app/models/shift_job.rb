class ShiftJob < ActiveRecord::Base
	
    # Relationships
    belongs_to :shift
    belongs_to :job
	
	
    # Validations
    # ==============================================================================
    # jobs can't be added to shifts until after the shift end time has passed, so a 
    # shift_job can only be created if the associated shift has ended
    validate :associated_shift_ended, :on => :create
    
    
    # Valdiation Helper Methods
    # private
    def associated_shift_ended 
	# shift has ended if it's end time is before the time it is now
	# puts self.shift.end_time
	# puts self.shift.end_time < Time.now
	errors.add(:shift_id, "shift is not over yet") unless self.shift.end_time < Time.now
	return self.shift.end_time < Time.now
	# return false
    end
    
end
