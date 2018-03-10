ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Check if there is a user logged in
  def logged_in?
    !session[:user_id].nil?
  end

  # Log in as a particular user
  def log_in_as(user)
    session[:user_id] = user.id
  end

  # Return the page title
  def full_title_t(page_title = '')
    base_title = "Visualize the World"
    if page_title.empty?
      base_title
    else
      "#{ page_title } | #{ base_title }"
    end
  end
end
