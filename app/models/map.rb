class Map < ApplicationRecord
  belongs_to :user
  has_many :map_contents, dependent: :destroy
  default_scope -> { order(updated_at: :desc) }
  validates :user_id, presence: true
  validates :title, presence: true
end
