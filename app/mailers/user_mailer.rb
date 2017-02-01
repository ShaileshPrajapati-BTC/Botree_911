class UserMailer < ApplicationMailer

  def send_password_notification(user)
    @user = user
    mail to:@user.email, subject: 'Your password'
  end
end
