require 'test_helper'

class StoreTest < ActiveSupport::TestCase
  # Test relationships
  should have_many(:assignments)
  should have_many(:employees).through(:assignments)
  should have_many(:shifts).through(:assignments)
  
  # Test basic validations
  should validate_presence_of(:name)
  should validate_presence_of(:street)
  should validate_presence_of(:city)
  # tests for zip
  should allow_value("15213").for(:zip)
  should_not allow_value("bad").for(:zip)
  should_not allow_value("1512").for(:zip)
  should_not allow_value("152134").for(:zip)
  should_not allow_value("15213-0983").for(:zip)
  # tests for state
  should allow_value("OH").for(:state)
  should allow_value("PA").for(:state)
  should allow_value("WV").for(:state)
  should_not allow_value("bad").for(:state)
  should_not allow_value("NY").for(:state)
  should_not allow_value(10).for(:state)
  should_not allow_value("CA").for(:state)
  # tests for phone
  should allow_value("4122683259").for(:phone)
  should allow_value("412-268-3259").for(:phone)
  should allow_value("412.268.3259").for(:phone)
  should allow_value("(412) 268-3259").for(:phone)
  should_not allow_value("2683259").for(:phone)
  should_not allow_value("14122683259").for(:phone)
  should_not allow_value("4122683259x224").for(:phone)
  should_not allow_value("800-EAT-FOOD").for(:phone)
  should_not allow_value("412/268/3259").for(:phone)
  should_not allow_value("412-2683-259").for(:phone)
  
  
  # Establish context
  # Testing other methods with a context
  context "Creating three stores with two employees and some shifts" do
    # create the objects I want with factories
    setup do 
      # stores
      @cmu = FactoryGirl.create(:store)
      @hazelwood = FactoryGirl.create(:store, :name => "Hazelwood", :active => false)
      @oakland = FactoryGirl.create(:store, :name => "Oakland", :phone => "412-268-8211")
      
      # employees
      @ed = FactoryGirl.create(:employee)
      @cindy = FactoryGirl.create(:employee, :first_name => "Cindy", :last_name => "Crawford", :ssn => "084-35-9822", :date_of_birth => 17.years.ago.to_date)
      @john = FactoryGirl.create(:employee, :first_name => "John", :last_name => "Johnson")
      @kathryn = FactoryGirl.create(:employee, :first_name => "Kathryn", :last_name => "Janeway", :role => "manager", :date_of_birth => 30.years.ago.to_date)
      
      # some assignments (all current)
      @assign_ed = FactoryGirl.create(:assignment, :employee => @ed, :store => @cmu, :end_date => nil)
      @assign_cindy = FactoryGirl.create(:assignment, :employee => @cindy, :store => @cmu, :end_date => nil)
      @assign_john = FactoryGirl.create(:assignment, :employee => @john, :store => @cmu, :end_date => nil)
      @assign_kathryn = FactoryGirl.create(:assignment, :employee => @kathryn, :store => @cmu, :end_date => nil)
	  
      # assign a few shifts (to test shift_hours_worked method)
      # for ed
      @yesterdayShift = FactoryGirl.create(:shift, :assignment => @assign_ed, :date => Date.yesterday, :start_time => 1.day.ago)
      @lastWeekShift = FactoryGirl.create(:shift, :assignment => @assign_ed, :date => 7.days.ago.to_date, :start_time => 7.days.ago)
      @lastMonthShift = FactoryGirl.create(:shift, :assignment => @assign_ed, :date => 30.days.ago.to_date, :start_time => 30.days.ago)
      # for john johnson
      @john1 = FactoryGirl.create(:shift, :assignment => @assign_john, :date => 7.days.ago.to_date, :start_time => 7.days.ago)
      @john2 = FactoryGirl.create(:shift, :assignment => @assign_john, :date => 8.days.ago.to_date, :start_time => 8.days.ago)
      @john3 = FactoryGirl.create(:shift, :assignment => @assign_john, :date => 9.days.ago.to_date, :start_time => 9.days.ago)
      @john4 = FactoryGirl.create(:shift, :assignment => @assign_john, :date => 19.days.ago.to_date, :start_time => 19.days.ago)
      
    end
    
    # and provide a teardown method as well
    teardown do
      @cmu.destroy
      @hazelwood.destroy
      @oakland.destroy
      
      @ed.destroy
      @cindy.destroy
      @kathryn.destroy
      @john.destroy
      
      @assign_ed.destroy
      @assign_cindy.destroy
      @assign_kathryn.destroy
      @assign_john.destroy
      
      @yesterdayShift.destroy
      @lastWeekShift.destroy
      @lastMonthShift.destroy
      @john1.destroy
      @john2.destroy
      @john3.destroy
      @john4.destroy
      
      
    end
  
    # now run the tests:
    # test one of each factory (not really required, but not a bad idea)
    should "show that all factories are properly created" do
      assert_equal "CMU", @cmu.name
      assert @oakland.active
      deny @hazelwood.active
    end
    
    # test stores must have unique names
    should "force stores to have unique names" do
      repeat_store = FactoryGirl.build(:store, :name => "CMU")
      deny repeat_store.valid?
    end
    
    # test the callback is working 'reformat_phone'
    should "shows that Oakland's phone is stripped of non-digits" do
      assert_equal "4122688211", @oakland.phone
    end
    
    # test the scope 'alphabetical'
    should "shows that there are three stores in in alphabetical order" do
      assert_equal ["CMU", "Hazelwood", "Oakland"], Store.alphabetical.map{|s| s.name}
    end
    
    # test the scope 'active'
    should "shows that there are two active stores" do
      assert_equal 2, Store.active.size
      assert_equal ["CMU", "Oakland"], Store.active.alphabetical.map{|s| s.name}
    end
    
    # test the scope 'inactive'
    should "shows that there is one inactive store" do
      assert_equal 1, Store.inactive.size
      assert_equal ["Hazelwood"], Store.inactive.alphabetical.map{|s| s.name}
    end
	
	# test the address method
	should "shows that the address method returns a string of the store's complete address" do
		assert_equal @oakland.address, "5000 Forbes Avenue, Pittsburgh, PA 15213"
	end
	
	#test the pretty_phone method
	should "shows that the pretty_phone method returns a prettily formatted phone number" do	
		assert_equal "412-268-8211", @oakland.pretty_phone
	end
	
	# test the active_status method
	should "shows that the active_status method returns a string indicating the store's active/inactive status" do
		assert_equal "active", @oakland.active_status
		assert_equal "inactive", @hazelwood.active_status
	end
    
    # test the geocoding callback using a known address (5000 forbes avenue, pittsburgh, PA 15213)
    should "show that the geocoding callback retrieves the store's latitude and longitude based on its address" do
        # rounding to two decimal places because not sure what precision google maps geocoder will return
        assert_equal 40.44, @oakland.latitude.round(2)
        assert_equal -79.94, @oakland.longitude.round(2)
    end
	
    # test the shift_hours_worked method
    should "show that the shift_hours_worked method works" do
        # for default (14 days, 2 weeks)
        assert_equal 15, @cmu.shift_hours_worked
        # for custom number of days
        assert_equal 21, @cmu.shift_hours_worked(30)
    end
    
    # test current_employees method
    should "show that the current_employees method works" do
        assert_equal [], @hazelwood.current_employees
        assert_equal ["Crawford", "Gruberman", "Janeway", "Johnson"], @cmu.current_employees.map{|e| e.last_name}
    end
    
end # context
end # class
