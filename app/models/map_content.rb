class MapContent < ApplicationRecord
  belongs_to :map
  default_scope -> { order(country_code: :asc) }
  validates :map_id, presence: true
  validates :country_code, presence: true
end