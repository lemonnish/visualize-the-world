# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end

  def contact
    body = "Here's a message. Heck, it even has line breaks.
    Like I said, that was a single line break.

    Shall we make it 2?"
    message = Message.new(name: "Lauren Nishizaki",
                          email: "map@laurennishizaki.com",
                          subject: "Here's a contact form submission",
                          body: body)
    UserMailer.contact(message)
  end
end
