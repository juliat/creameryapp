class ShiftJob < ActiveRecord::Base
	
	# Relationships
	belongs_to :shift
	belongs_to :job
	
	
    # Validations
    # ==============================================================================
    # jobs can't be added to shifts until after the shift end time has passed, so a 
    # shift_job can only be created if the associated shift has ended
    validate :associated_shift_ended
    
    
    # Valdiation Helper Methods
    private
    def associated_shift_ended 
        past_shifts = Shift.past.map{|shift| shift.id}
        return past_shifts.include?(self.shift_id)
    end
	
end
