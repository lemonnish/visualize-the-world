class Map < ApplicationRecord
  belongs_to :user
  default_scope -> { order(updated_at: :desc) }
  validates :user_id, presence: true
end
