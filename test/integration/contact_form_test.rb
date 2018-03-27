require 'test_helper'

class ContactFormTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:lauren)
    @old_password = "password"
  end

  test "contact form submits" do
    get contact_path
    assert_select 'form' do
      assert_select '[action=?]', contact_path
      assert_select '[method="post"]'
    end
    # post a blank message
    post contact_path, params: { message: { name: "", email: "", subject: "", body: "" } }
    assert_template 'static_pages/contact'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors', 8

    # post a successful message
    assert_equal 0, ActionMailer::Base.deliveries.size
    name = "Foo Bar"
    email = "foobar@baz.com"
    subject = "Test"
    body = "Here's a testing email!"
    post contact_path, params: { message: { name: name, email: email,
                                            subject: subject, body: body } }
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
  end
end
