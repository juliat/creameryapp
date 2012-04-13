require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Test relationships
  should belong_to(:employee)
  
  # Test basic validations
  should validate_presence_of(:password_digest)
  
  # Test format for email
  # note: tests using context should check for uniqueness
  should allow_value("profh@cmu.edu").for(:email) # alpha chars permitted
  should allow_value("profh@cmu.ed").for(:email)
  should allow_value("profh@cmu.eduu").for(:email)
  
  should allow_value("profH@CMU.EDU").for(:email) # case insensitive
  should allow_value("profh+klingon@cmu.edu").for(:email) # plus is allowed
  should allow_value("profh_klingon@cmu.edu").for(:email) # underscore is allowed
  should allow_value("profh.klingon@cmu.edu").for(:email) # dot is allowed
  should allow_value("profh-klingon@cmu.edu").for(:email) # dash is allowed
  should allow_value("-profh@cmu.edu").for(:email) # even at the beginning
  should allow_value("profh42@cmu.edu").for(:email) # numbers are allowed in username
  should allow_value("profh@cmu83.edu").for(:email) # numbers are allowed in domain
  
  should_not allow_value("prof h@cmu.edu").for(:email) # no spaces
  should_not allow_value("profh>@cmu.edu").for(:email) # > char is not allowed
  should_not allow_value("prof~h@cmu.edu").for(:email) # no ~
  should_not allow_value("prof:h@cmu.edu").for(:email) # no :
  should_not allow_value("profh@cmu.e").for(:email)
   
  # Test format for password_digest

  
  context "Creating one store, three employees, three assignments, and two users" do
    setup do
        # store
        @CMU = FactoryGirl.create(:store)
        
        # employees
        @Ed = FactoryGirl.create(:employee)
        @Ned = FactoryGirl.create(:employee, :first_name => "Ned")
        @Ted = FactoryGirl.create(:employee, :first_name => "Ted")
        
        # assignments
        @EdAssign = FactoryGirl.create(:assignment, :employee => @Ed, :store => @CMU)
        @NedAssign = FactoryGirl.create(:assignment, :employee => @Ned, :store => @CMU, :end_date => nil)
        @TedAssign = FactoryGirl.create(:assignment, :employee => @Ted, :store => @CMU, :end_date => nil)
        
        # users
        @EdUser = FactoryGirl.create(:user, :employee => @Ed)
        @NedUser = FactoryGirl.create(:user, :employee => @Ned, :email => "ned@example.com")
        @TedUser = FactoryGirl.create(:user, :employee => @Ted, :email => "ted@example.com")
    end
    
    teardown do
        @CMU.destroy
        
        @Ed.destroy
        @Ned.destroy
        @Ted.destroy
        
        @EdAssign.destroy
        @NedAssign.destroy
        @TedAssign.destroy
    end
    
    should "show that a user can't be created for an inactive employee" do
        @Ed.active = false
        @EdUser = FactoryGirl.build(:user, :employee => @Ned)
        deny @EdUser.valid?
    end
    
    should "show that emails must be unique in the system" do
        @EdDup = FactoryGirl.build(:employee)
        @EdDupUser = FactoryGirl.build(:user, :employee => @EdDup, :email => @EdUser.email)
        deny @EdDupUser.valid?
    end
    
  end
  
end
