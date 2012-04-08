require 'test_helper'

class ShiftJobTest < ActiveSupport::TestCase
    
    # Test relationships
    should belong_to(:shift)
    should belong_to(:job)
    
    # need a context to test associated_shift_ended validation:
    # jobs can't be added to shifts until after the shift end time has passed, so a 
    # shift_job can only be created if the associated shift has ended
    
end
