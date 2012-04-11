require 'test_helper'

class ShiftTest < ActiveSupport::TestCase

	# Test relationships
	should have_many(:jobs).through(:shift_jobs)
	should belong_to(:assignment)
	should have_one(:store).through(:assignment)
	should have_one(:employee).through(:assignment)
	
	# Test validations
	should validate_presence_of(:start_time)

	# need to test date
	
	context "Creating four employees assigned to two stores with two jobs and six shifts" do
		# create the objects I want in my test context using factories
		setup do
			# stores
			@CMU = FactoryGirl.create(:store)
			@Squirrel = FactoryGirl.create(:store, :name => "Squirrel Hill", :street => "4000 Murray Ave.")
			# employees
			@Luke = FactoryGirl.create(:employee, :first_name => "Luke", :last_name => "Skywalker")
			@Leia = FactoryGirl.create(:employee, :first_name => "Leia", :last_name => "Organa")
			@Hans = FactoryGirl.create(:employee, :first_name => "Hans", :last_name => "Solo")
			@ObiWan	= FactoryGirl.create(:employee, :first_name => "Obi-Wan", :last_name => "Kenobi")
			# assignments
			# Luke, Leia, and Hans all have current assignments, but Obi-Wan does not
			@LukeAssign = FactoryGirl.create(:assignment, :store => @CMU, :employee => @Luke, :end_date => nil)
			@LeiaAssign = FactoryGirl.create(:assignment, :store => @Squirrel, :employee => @Leia, :end_date => nil)
			@HansAssign = FactoryGirl.create(:assignment, :store => @Squirrel, :employee => @Hans, :end_date => nil)
			@ObiWanAssign = FactoryGirl.create(:assignment, :store => @CMU, :employee => @ObiWan)			
			# jobs
			@Cashier = FactoryGirl.create(:job)
			@Jedi = FactoryGirl.create(:job, :name => "Jedi", :description => "Maintain balance in the force.")
			# shifts
			# =================
			# shift that started on 3/1/2012 at 15:00 (3pm) and ended at 19:00 (7pm)
			@Shift1 = FactoryGirl.create(:shift, 
										:assignment => @LukeAssign,
										:date => Date.new(2012, 3, 1),
										:start_time => Time.local(2012, 3, 1, 15, 0, 0), 
										:end_time => Time.local(2012, 3, 1, 19, 0, 0)
									   )
			@Shift2 = FactoryGirl.create(:shift,
										:assignment => @LukeAssign,
										:date => Date.new(2012, 3, 2),
										:start_time => Time.local(2012, 3, 2, 10, 0, 0),
										:end_time => Time.local(2012, 3, 2, 13, 0, 0),
									   )
			@Shift3 = FactoryGirl.create(:shift,
										:assignment => @LeiaAssign,
										:date => Date.new(2012, 4, 1),
										:start_time => Time.local(2012, 4, 1, 9, 0, 0),
										:end_time => Time.local(2012, 4, 1, 10, 0, 0)
									   )
			@Shift4 = FactoryGirl.create(:shift,
										:assignment => @HansAssign,
										:date => Date.today,
										:start_time => Time.now,
										:end_time => nil
									   )
			@Shift5 = FactoryGirl.create(:shift,
										:assignment => @LeiaAssign,
										:date => Date.today + 7.days,
										:start_time => Time.now + 7.days,
										:end_time => nil
									   )
			@Shift6 = FactoryGirl.create(:shift,
										:assignment => @LukeAssign,
										:date => Date.today + 14.days,
										:start_time => Time.now + 14.days,
										:end_time => nil
									   )
								
			# shift_jobs
			# =================
			# Luke's first shift has cashier and jedi as jobs
			@Shift1Cashier = FactoryGirl.create(:shift_job, :shift => @Shift1, :job => @Cashier)
			@Shift1Jedi = FactoryGirl.create(:shift_job, :shift => @Shift1, :job => @Cashier)
			
			# Leia's first shift has cashier as job
			@Shift3Cashier = FactoryGirl.create(:shift_job, :shift => @Shift3, :job => @Cashier)
		end # end context setup
		
		
		# providing teardown method for all objects
		teardown do
			# stores
			@CMU.destroy
			@Squirrel.destroy
			# employees
			@Luke.destroy
			@Leia.destroy
			@Hans.destroy
			@ObiWan.destroy
			# assignments
			@LukeAssign.destroy
			@LeiaAssign.destroy
			@HansAssign.destroy
			@ObiWanAssign.destroy
			# jobs
			@Cashier.destroy
			@Jedi.destroy
			# shifts
			@Shift1.destroy
			@Shift2.destroy
			@Shift3.destroy
			@Shift4.destroy
			@Shift5.destroy
			@Shift6.destroy
			# shift jobs
			@Shift1Cashier.destroy
			@Shift1Jedi.destroy
			@Shift3Cashier.destroy
		end # end teardown
		
		# tests
		# ==========================================================================
		should "have a method which returns a boolean indicating whether a shift has been completed" do
			assert_equal true, @Shift1.completed?
			assert_equal true, @Shift3.completed?
			assert_equal false, @Shift4.completed?
			assert_equal false, @Shift2.completed?
		end
		
		should "have a scope that returns all completed shifts (ones with associated jobs)" do
			# check that the right shifts are returned
			assert_equal [@Shift1, @Shift3].map{|shift| shift.date}, Shift.completed.all.map{|shift| shift.date}
		end
		
		should "have a scope that returns all incomplete shifts (that have no associated jobs)" do
			assert_equal [@Shift2, @Shift4, @Shift5, @Shift6].map{|shift| shift.date}, Shift.incomplete.map{|shift| shift.date}
		end
			
		should "have a scope to find all shifts for a given store" do
			assert_equal [@Shift3, @Shift4, @Shift5].map{|shift| shift.date}, Shift.for_store(@Squirrel.id).map{|shift| shift.date}
		end
		
		should "have a scope to find all shifts for a given employee" do
			# if the first array "-" the second array is equal to the empty array, then
			# the first array contained all the elements in the second array
			assert_equal [@Shift1, @Shift2, @Shift6].map{|shift| shift.date}, Shift.for_employee(@Luke.id).map{|shift| shift.date}
			assert_equal [@Shift4].map{|shift| shift.date}, Shift.for_employee(@Hans.id).map{|shift| shift.date}
			assert_equal [], Shift.for_employee(@ObiWan.id)
		end
		
		should "have a scope which returns all shifts which have a date in the past" do
			assert_equal [@Shift1, @Shift2, @Shift3].map{|shift| shift.date}, Shift.past.map{|shift| shift.date}
		end
		
		should "have a scope which returns all upcoming shifts (with a date in the present or future"  do
			assert_equal [@Shift4, @Shift5, @Shift6].map{|shift| shift.date}, Shift.upcoming.map{|shift| shift.date}
		end
		
		should "have a scope that returns all the upcoming shifts in the next x days" do
			assert_equal [@Shift4, @Shift5].map{|shift| shift.date}, Shift.for_next_days(7).map{|shift| shift.date}
		end
		
		# should "have a scope that returns all the past shifts in the previous x days" do
		# end
		
		should "have a scope that returns all the shifts in chronological (ascending) order" do
			shifts_in_chrono_order = [@Shift1, @Shift2, @Shift3, @Shift4, @Shift5, @Shift6]
			assert_equal shifts_in_chrono_order.map{|shift| shift.date}, Shift.chronological.map{|shift| shift.date}
		end
		
		should "have a scope that returns all shifts ordered by store" do
			# Shifts 1, 2, and 6 are associated with the CMU store. 3, 4, and 5 are associated with Squirrel Hill.
			shifts_by_store = [@Shift1, @Shift2, @Shift6, @Shift3, @Shift4, @Shift5]
			assert_equal shifts_by_store.map{|shift| shift.date}, Shift.by_store.map{|shift| shift.date}
		end
		
		should "have a scope that returns all shifts ordered by employee" do
			# shifts 1, 2, 6 belong to Luke. Shifts 3 and 5 belond to Leia. Shift 4 belongs to Hans.
			shifts_by_employee = [@Shift3, @Shift5, @Shift1, @Shift2, @Shift6, @Shift4]
			assert_equal shifts_by_employee.map{|shift| shift.employee.name}, Shift.by_employee.map{|shift| shift.employee.name}
		end
			
	end

end
