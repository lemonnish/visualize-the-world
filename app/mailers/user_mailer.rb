class UserMailer < ApplicationMailer
  before_action :define_css

  def account_activation(user)
    @user = user
    mail to: user.email, subject: full_subject("Account activation")
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: full_subject("Password reset")
  end

  def contact(message)
    @message = message
    mail to: ENV['PERSONAL_EMAIL'],
         from: "#{ @message.name } <#{ @message.email }>",
         subject: full_subject(@message.subject)
  end

  private

    # generate the full subject of all emails
    def full_subject(title)
      "[Visualize the World] #{ title }"
    end

    # load the CSS
    def define_css
      @css = Rails.application.assets_manifest
                  .find_sources('mailer.css').first.to_s.html_safe
    end
end
