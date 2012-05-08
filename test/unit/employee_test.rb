require 'test_helper'

class EmployeeTest < ActiveSupport::TestCase
  # Test relationships
  should have_many(:assignments)
  should have_many(:stores).through(:assignments)
  should have_many(:shifts).through(:assignments)
  should have_one(:user)
  
  # Test basic validations
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)
  # tests for phone
  should allow_value("4122683259").for(:phone)
  should allow_value("412-268-3259").for(:phone)
  should allow_value("412.268.3259").for(:phone)
  should allow_value("(412) 268-3259").for(:phone)
  should allow_value(nil).for(:phone)
  should_not allow_value("2683259").for(:phone)
  should_not allow_value("14122683259").for(:phone)
  should_not allow_value("4122683259x224").for(:phone)
  should_not allow_value("800-EAT-FOOD").for(:phone)
  should_not allow_value("412/268/3259").for(:phone)
  should_not allow_value("412-2683-259").for(:phone)
  # tests for ssn
  should allow_value("123456789").for(:ssn)
  should_not allow_value("12345678").for(:ssn)
  should_not allow_value("1234567890").for(:ssn)
  should_not allow_value("bad").for(:ssn)
  should_not allow_value(nil).for(:ssn)
  # test date_of_birth
  should allow_value(17.years.ago.to_date).for(:date_of_birth)
  should allow_value(15.years.ago.to_date).for(:date_of_birth)
  should allow_value(14.years.ago.to_date).for(:date_of_birth)
  should_not allow_value(13.years.ago).for(:date_of_birth)
  should_not allow_value("bad").for(:date_of_birth)
  should_not allow_value(nil).for(:date_of_birth)
  # tests for role
  should allow_value("admin").for(:role)
  should allow_value("manager").for(:role)
  should allow_value("employee").for(:role)
  should_not allow_value("bad").for(:role)
  should_not allow_value("hacker").for(:role)
  should_not allow_value(10).for(:role)
  should_not allow_value("vp").for(:role)
  should_not allow_value(nil).for(:role)
  
  
  context "Creating seven employees of three levels" do
    # create the objects I want with factories
    setup do 
      # one store
      @cmu = FactoryGirl.create(:store)
      # many employees
      @ed = FactoryGirl.create(:employee)
      @cindy = FactoryGirl.create(:employee, :first_name => "Cindy", :last_name => "Crawford", :ssn => "084-35-9822", :date_of_birth => 17.years.ago.to_date)
      @john = FactoryGirl.create(:employee, :first_name => "John", :last_name => "Johnson")
      @ralph = FactoryGirl.create(:employee, :first_name => "Ralph", :last_name => "Wilson", :active => false, :date_of_birth => 16.years.ago.to_date)
      @ben = FactoryGirl.create(:employee, :first_name => "Ben", :last_name => "Sisko", :role => "manager", :phone => "412-268-2323")
      @kathryn = FactoryGirl.create(:employee, :first_name => "Kathryn", :last_name => "Janeway", :role => "manager", :date_of_birth => 30.years.ago.to_date)
      @alex = FactoryGirl.create(:employee, :first_name => "Alex", :last_name => "Heimann", :role => "admin")
      
      # some assignments
      @assign_ed = FactoryGirl.create(:assignment, :employee => @ed, :store => @cmu)
      @assign_cindy = FactoryGirl.create(:assignment, :employee => @cindy, :store => @cmu, :end_date => nil)
      @assign_john = FactoryGirl.create(:assignment, :employee => @john, :store => @cmu, :end_date => nil)
      @assign_kathryn = FactoryGirl.create(:assignment, :employee => @kathryn, :store => @cmu)
	  # adding objects to test most_recent_assignment method
	  @benji = FactoryGirl.create(:employee, :first_name => "Benji", :last_name => "Samson")
	  @old_assign_benji = FactoryGirl.create(:assignment, :employee => @benji, :store => @cmu, :start_date => 2.years.ago.to_date, :end_date => 1.year.ago.to_date)
	  @recent_assign_benji = FactoryGirl.create(:assignment, :employee => @benji, :store => @cmu, :start_date => 1.year.ago.to_date, :end_date => 1.month.ago.to_date)
      
      # assign a few shifts (to test shift_hours_worked method)
      # for ed
      @yesterdayShift = FactoryGirl.create(:shift, :assignment => @assign_cindy, :date => Date.yesterday, :start_time => 1.day.ago)
      @lastWeekShift = FactoryGirl.create(:shift, :assignment => @assign_cindy, :date => 7.days.ago.to_date, :start_time => 7.days.ago)
      @lastMonthShift = FactoryGirl.create(:shift, :assignment => @assign_cindy, :date => 30.days.ago.to_date, :start_time => 30.days.ago)
      # for john johnson
      @john1 = FactoryGirl.create(:shift, :assignment => @assign_john, :date => 7.days.ago.to_date, :start_time => 7.days.ago)
      @john2 = FactoryGirl.create(:shift, :assignment => @assign_john, :date => 8.days.ago.to_date, :start_time => 8.days.ago)
      @john3 = FactoryGirl.create(:shift, :assignment => @assign_john, :date => 9.days.ago.to_date, :start_time => 9.days.ago)
      @john4 = FactoryGirl.create(:shift, :assignment => @assign_john, :date => 19.days.ago.to_date, :start_time => 19.days.ago)
    end
    
    # and provide a teardown method as well
    #~ teardown do
      #~ @cmu.destroy
      #~ @ed.destroy
      #~ @cindy.destroy
      #~ @ralph.destroy
      #~ @john.destroy
      #~ @ben.destroy
      #~ @kathryn.destroy
      #~ @alex.destroy
	  #~ @benji.destroy
      #~ @assign_ed.destroy
      #~ @assign_cindy.destroy
      #~ @assign_john.destroy
	  #~ @old_assign_benji.destroy
	  #~ @recent_assign_benji.destroy
      #~ @yesterdayShift.destroy
      #~ @lastWeekShift.destroy
      #~ @lastMonthShift.destroy
      #~ @john1.destroy
      #~ @john2.destroy
      #~ @john3.destroy
      #~ @john4.destroy
    #~ end
  
    # now run the tests:
    # test employees must have unique ssn
    should "force employees to have unique ssn" do
      repeat_ssn = FactoryGirl.build(:employee, :first_name => "Steve", :last_name => "Crawford", :ssn => "084-35-9822")
      deny repeat_ssn.valid?
    end
    
    # test scope younger_than_18
    should "show there are two employees under 18" do
      assert_equal 2, Employee.younger_than_18.size
      assert_equal ["Crawford", "Wilson"], Employee.younger_than_18.alphabetical.map{|e| e.last_name}
    end
    
    # test scope younger_than_18
    should "show there are five employees over 18" do
      assert_equal 6, Employee.is_18_or_older.size
      assert_equal ["Gruberman", "Heimann", "Janeway", "Johnson", "Samson", "Sisko"], Employee.is_18_or_older.alphabetical.map{|e| e.last_name}
    end
    
    # test the scope 'active'
    should "shows that there are six active employees" do
      assert_equal 7, Employee.active.size
      assert_equal ["Crawford", "Gruberman", "Heimann", "Janeway", "Johnson", "Samson", "Sisko"], Employee.active.alphabetical.map{|e| e.last_name}
    end
    
    # test the scope 'inactive'
    should "shows that there is one inactive employee" do
      assert_equal 1, Employee.inactive.size
      assert_equal ["Wilson"], Employee.inactive.alphabetical.map{|e| e.last_name}
    end
    
    # test the scope 'regulars'
    should "shows that there are 4 regular employees: Ed, Cindy, Johnson, Samson, and Ralph" do
      assert_equal 5, Employee.regulars.size
      assert_equal ["Crawford","Gruberman", "Johnson", "Samson", "Wilson"], Employee.regulars.alphabetical.map{|e| e.last_name}
    end
    
    # test the scope 'managers'
    should "shows that there are 2 managers: Ben and Kathryn" do
      assert_equal 2, Employee.managers.size
      assert_equal ["Janeway", "Sisko"], Employee.managers.alphabetical.map{|e| e.last_name}
    end
    
    # test the scope 'admins'
    should "shows that there is one admin: Alex" do
      assert_equal 1, Employee.admins.size
      assert_equal ["Heimann"], Employee.admins.alphabetical.map{|e| e.last_name}
    end
    
    # test the method 'name'
    should "shows name as last, first name" do
      assert_equal "Heimann, Alex", @alex.name
    end    
    
    # test the method 'proper_name'
    should "shows proper name as first and last name" do
      assert_equal "Alex Heimann", @alex.proper_name
    end
    
    # test the method 'current_assignment'
    should "shows return employee's current assignment if it exists" do
      assert_equal "CMU", @cindy.current_assignment.store.name
      assert_nil @ed.current_assignment
    end
    
    # test the callback is working 'reformat_ssn'
    should "shows that Cindy's ssn is stripped of non-digits" do
      assert_equal "084359822", @cindy.ssn
    end
    
    # test the callback is working 'reformat_phone'
    should "shows that Ben's phone is stripped of non-digits" do
      assert_equal "4122682323", @ben.phone
    end
    
    # test the method 'over_18?'
    should "shows that over_18? boolean method works" do
      assert @ed.over_18?
      deny @cindy.over_18?
    end
    
    # test the method 'age'
    should "shows that age method returns the correct value" do
      assert_equal 19, @ed.age
      assert_equal 17, @cindy.age
      assert_equal 30, @kathryn.age
    end

	#test the pretty_phone method
	should "shows that the pretty_phone method returns a prettily formatted phone number" do	
		assert_equal  "412-268-2323", @ben.pretty_phone
	end
	
	#test the pretty_ssn method
	should "shows that the pretty_ssn method returns a prettily formatted ssn" do
		assert_equal "084-35-9822", @cindy.pretty_ssn
	end
	
	# test the active_status method
	should "show that the active_status method returns a string indicating the employee's 
    status as active or inactive" do
		assert_equal "inactive", @ralph.active_status
		assert_equal "active", @cindy.active_status
	end
	
	# test the most_recent_assignment method
	# should "shows that the most recent assignment method works" do
		# assert_equal @recent_assign_benji, @benji.most_recent_assignment
	# end
    
    # test the manager method
    should "show that the manager returns the manager for an employee (or nil if the 
    employee is not a low-level employee or has no current assignment" do
        # kathryn is cindy's manager at the CMU store
        assert_equal @kathryn, @cindy.manager
        # ed has no current assignment ==> no manager
        assert_nil @ed.manager
    end
    
    # test the shift_hours_worked method
    should "show that the shift_hours_worked method returns the cumulative shift hours 
    worked  in a given time range by an employee as an integer" do
        # someone with no hours
        assert_equal 0, @ed.shift_hours_worked
        # someone with many hours (using default time range of 2 weeks)
        assert_equal 6, @cindy.shift_hours_worked
        assert_equal 9, @john.shift_hours_worked
        # using time range other than default
        assert_equal 9, @cindy.shift_hours_worked(30)
    end
    
    # test the top_employees method
    should "show that the top_employees method returns employees who have worked the most hours (>0) in the past n days" do
        # using defaults (7 employees, past 14 days)
        assert_equal ["Johnson", "Crawford"], Employee.top_employees.map{|e| e.last_name}
        
        # 5 employees, past 5 days
        assert_equal ["Crawford"], Employee.top_employees(5, 5).map{|e| e.last_name}
    end
    
    # test the last_shift_worked method
    should "show that the last_shift_worked method returns the most recent shift that an employee has worked" do
        assert_equal @john1, @john.last_shift_worked
    end
    
  end
end
