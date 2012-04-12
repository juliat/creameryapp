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
            d = Date.yesterday
            @Shift1 = FactoryGirl.create(:shift, :assignment => @Assign, :date => d, 
                                        :start_time => Time.local(d.year, d.month, d.day, 10, 0, 0), 
                                        :end_time => Time.local(d.year, d.month, d.day, 12, 0, 0))
            d = Date.tomorrow
            @Shift2 = FactoryGirl.create(:shift, :assignment => @Assign, :date => d, 
                            :start_time => Time.local(d.year, d.month, d.day, 10, 0, 0), 
                            :end_time => Time.local(d.year, d.month, d.day, 12, 0, 0))
        end # end setup
        
        #~ teardown do
           #~ @Employee.destroy
           #~ @Store.destroy
           #~ @Assign.destroy
           #~ @Job.destroy
           #~ @Shift1.destroy
        #~ end
        
        #~ should "show that a shift job can only be created if the associated shift is ended" do
            #~ @Shift_Job_1 = FactoryGirl.build(:shift_job, :shift => @Shift1, :job => @Job)
            #~ assert @Shift_Job_1.valid?
            #~ @Shift_Job_2 = FactoryGirl.build(:shift_job, :shift => @Shift2, :job => @Job)
            #~ deny @Shift_Job_2.valid?, :message => "can only add jobs to shifts after they have ended")
        #~ end
        
    end
end
