class UserMailer < ActionMailer::Base
  default :from => "from@example.com"
  
  default_url_options[:host] = HOST_NAME
  
  def email_verification(user)
    setup_email(user)
    @subject         += "Your account has been created. Please verify your email address"
  end  

  def forgot_password(user)
    setup_email(user)
    @subject          += "You have requested a new password"
  end
  

protected
  # Change YourApp to whatever you application is called
  def setup_email(user)
    @recipients  = user.email
    @body[:user] = user
    @from        = FROM_EMAIL
    @subject = case ENV['RAILS_ENV'] 
      when 'development' 
        "[YourApp Development] "
      when 'staging' 
        "[YourApp Staging] "
      else "[YourApp] "
    end
    @sent_on     = Time.now
    headers       "Reply-to" => FROM_EMAIL
  end
end
