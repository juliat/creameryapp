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
		
	
	context "Creating four jobs" do
		setup do
			# active
			@Cashier = FactoryGirl.create(:job)
			@Jedi = FactoryGirl.create(:job, :name => "Jedi", :description => "Maintain balance in the force.")
			# inactive
			@Pirate = FactoryGirl.create(:job, :name => "Pirate", :description => "Swashbuckler.", :active => false)
			@Ninja = FactoryGirl.create(:job, :name => "Ninja", :description => "Stealthily sneak", :active => false)
		end
		
		teardown do
			@Cashier.destroy
			@Jedi.destroy
			@Pirate.destroy
			@Ninja.destroy
		end
		
		should "have a scope which returns all jobs ordered alphabetically" do
			assert_equal ["Cashier", "Jedi", "Ninja", "Pirate"], Job.alphabetical.map{|job| job.name}
		end
		
		should "have a scope which returns only active jobs" do
			assert_equal ["Cashier", "Jedi"], Job.active.alphabetical.map{|job| job.name}
		end
		
		should "have a scope which returns only inactive jobs" do
			assert_equal ["Ninja", "Pirate"], Job.inactive.alphabetical.map{|job| job.name}
		end
	end # end context
end
