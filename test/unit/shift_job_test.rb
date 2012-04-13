require 'test_helper'

class ShiftJobTest < ActiveSupport::TestCase
    
    # Test relationships
    should belong_to(:shift)
    should belong_to(:job)
    
    # need a context to test associated_shift_ended validation:
    # jobs can't be added to shifts until after the shift end time has passed, so a 
    # shift_job can only be created if the associated shift has ended
    context "Creating a store, employee, assignment, one job, and one shifts" do
        setup do
            @Employee = FactoryGirl.create(:employee)
            @Store = FactoryGirl.create(:store, :name => "Narnia")
            @Assign = FactoryGirl.create(:assignment, :employee => @Employee, :store => @Store)
            @Job = FactoryGirl.create(:job)
            d1 = Date.yesterday
            @Shift1 = FactoryGirl.create(:shift, :assignment => @Assign, :date => d1, 
                                        :start_time => Time.local(d1.year, d1.month, d1.day, 10, 0, 0), 
                                        :end_time => Time.local(d1.year, d1.month, d1.day, 2, 0, 0))
            d2 = Date.tomorrow
            @Shift2 = FactoryGirl.create(:shift, :assignment => @Assign, :date => d2, 
                            :start_time => Time.local(d2.year, d2.month, d2.day, 10, 0, 0), 
                            :end_time => Time.local(d2.year, d2.month, d2.day, 2, 0, 0))
        end # end setup
        
        #~ teardown do
           #~ @Employee.destroy
           #~ @Store.destroy
           #~ @Assign.destroy
           #~ @Job.destroy
           #~ @Shift1.destroy
           #~ @Shift2.destroy
        #~ end
        
        should "show that a shift job can only be created if the associated shift is ended" do
            @Shift_Job_1 = FactoryGirl.build(:shift_job, :shift => @Shift1, :job => @Job)
            assert @Shift_Job_1.valid?, "should be able to add jobs to shift that has ended"
            @Shift_Job_2 = FactoryGirl.build(:shift_job, :shift => @Shift2, :job => @Job)
            # Shift_Job_2 should not be valid because you should not be able to create a shift_job
            # for a shift that has not yet ended
            puts "start time: " + @Shift2.start_time.to_s
            puts "end time: " + @Shift2.end_time.to_s
            puts "now time: " + Time.now.to_s
            puts @Shift2.end_time < Time.now
            assert_equal false, @Shift_Job_2.associated_shift_ended
            assert_equal false, @Shift_Job_2.valid?
        end
        
    end
end
