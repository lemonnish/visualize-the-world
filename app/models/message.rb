class Message
  include ActiveModel::Model
  attr_accessor :name, :email, :subject, :body
  validates :name, presence: true
  validates :email, presence: true
  validates :subject, presence: true
  validates :body, presence: true

  # Sends an email with the contents of the contact form
  def send_contact_email
    UserMailer.contact(self).deliver_now
  end
end
