require 'test_helper'

class ShiftTest < ActiveSupport::TestCase

	# Test relationships
	should have_many(:jobs).through(:shift_jobs)
	should belong_to(:assignment)
	should have_one(:store).through(:assignment)
	should have_one(:employee).through(:assignment)
	
	# Test validations
	should validate_presence_of(:date)
	should validate_presence_of(:start_time)
	
	should allow_value(Date.today).for(:date) # today
	should allow_value(Date.1.week.from_now.to_date).for(:date) # future
	should allow_value(Date.2.weeks.ago.to_date).for(:date) # past

end
