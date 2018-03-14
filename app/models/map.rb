class Map < ApplicationRecord
  belongs_to :user
  has_many :map_contents, dependent: :destroy
  default_scope -> { order(updated_at: :desc) }
  validates :user_id, presence: true
  validates :title, presence: true

  # returns an array of all valid country codes
  def self.country_codes
    %w(CL DE FR LA)
  end

  # return the appropriate MapContent.comment
  self.country_codes.each do |country_code|
    define_method "comment_#{ country_code }" do
      content = map_contents.find_by(country_code: country_code)
      content ? content.comment : nil
    end
  end

  # updates all MapContent.country_code/comment pairs
  # if anything fails, returns false
  # some updates are still made
  def update_content(hash)
    hash.each do |comment_code, comment|
      # validates presence of country_code
      country_code = comment_code.to_s.split('_').last
      content = map_contents.find_by(country_code: country_code)
      if content.nil?
        errors.add(comment_code, "does not correspond to an existing country code on this map")
      else
        # update values
        content.update_attribute(:comment, comment)
      end
    end
    !errors.any?
  end
end
