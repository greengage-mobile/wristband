class UsersController < ApplicationController
  before_filter :login_required
  
  def verify_email
    @user = User.verify_email!(params[:email_validation_key])
    flash[:notice] = 'Your email address has been verified. You may now login to your account.'
    redirect_to login_path
  rescue UserVerificationError => error
    flash[:error] = error.message
    redirect_to login_path
  end
  
  def forgot_password
    if request.post?
      if @user = User.find_by_email(params[:user][:email])
        @user.password = Wristband::Support.random_string(6)
        @user.save!
        UserNotifier::deliver_forgot_password(@user)
        flash[:notice] = 'A new password has been generated and emailed to the address you entered.'
        redirect_to login_path and return
      else
        @user = User.new
        @user.errors.add("email", "Cannot find that email address, did you mistype?")
      end
    end
  end
  
  
private
  def login_required
    redirect_to login_path unless logged_in?
  end

end