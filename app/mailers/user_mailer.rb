class UserMailer < ActionMailer::Base
  default from: "julialt@gmail.com"
  
    def new_user_message(user)
        @user = user
        mail(:to => user.email, :subject => "Your A&M Creamery Account")
    end
    
    
    def password_reset(user)
      @user = user
      mail(:to => user.email, :subject => "Lost A&M Creamery Password")
    end 
  
end
