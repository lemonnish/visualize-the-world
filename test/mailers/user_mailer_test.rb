require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:lauren)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Account activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@laurennishizaki.com"], mail.from
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end

  test "password_reset" do
    user = users(:lauren)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "Password reset", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@laurennishizaki.com"], mail.from
    assert_match user.reset_token,        mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end

  test "contact" do
    name = "Lauren"
    email = "foobar@laurennishizaki.com"
    subject = "Here's something interesting"
    body = "Did you know that... wait, I lost my train of thought."
    message = Message.new(name: name, email: email, subject: subject, body: body)
    mail = UserMailer.contact(message)
    assert_equal "[Visualize the World] #{ subject }", mail.subject
    assert_equal ["#{ email }"], mail.from
    assert_match CGI.escapeHTML(body), mail.body.encoded
    assert_match CGI.escapeHTML(email), mail.body.encoded
    assert_match CGI.escapeHTML(name), mail.body.encoded
    assert_match CGI.escapeHTML(subject), mail.body.encoded
  end
end
