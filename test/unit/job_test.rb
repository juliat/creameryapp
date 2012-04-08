require 'test_helper'

class JobTest < ActiveSupport::TestCase
	
	# Test relationships
	should have_many(:shift_jobs)
	
	# Test format of name
	should allow_value("Cashier").for(:name)
	# just sanity checking data values
	should_not allow_value(10).for(:name)
	should_not allow_value(15.2).for(:name)
	should_not allow_value(Date.today).for(:name)
	
end
