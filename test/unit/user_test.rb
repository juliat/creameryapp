require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Test relationships
  should belong_to(:employee)
  
  # Test basic validations
  # should validate_presence_of(:password_digest)
  
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
  should_not allow_value("profh@andrew-cmu.edu").for(:email)
  
  # Test format for password_digest
  # forthcoming
  
end
