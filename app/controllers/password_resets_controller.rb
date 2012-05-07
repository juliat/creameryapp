class PasswordResetsController < ApplicationController
    def create
      user = User.find_by_email(params[:email])
      # send user password reset if we can find them
      user.send_password_reset if user
      redirect_to root_url, :notice => "Email sent with password reset instructions."
    end

    def edit
      @user = User.find_by_password_reset_token!(params[:id])
    end

    def update
      @user = User.find_by_password_reset_token!(params[:id])
      # reset should expire after an hour
      if @user.password_reset_sent_at < 1.hour.ago
        redirect_to new_password_reset_path, :alert => "Password reset has expired."
      # password reset is still good, so update user password and give success meassage
      elsif @user.update_attributes(params[:user])
        redirect_to root_url, :notice => "Password has been reset!"
      else
        render :edit
      end
    end
end

