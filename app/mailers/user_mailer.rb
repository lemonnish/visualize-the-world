class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end

  def contact(message)
    @message = message
    mail to: ENV['PERSONAL_EMAIL'],
         from: "#{ @message.name } <#{ @message.email }>",
         subject: "[Visualize the World] #{ @message.subject }"
  end
end
