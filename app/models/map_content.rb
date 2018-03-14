class MapContent < ApplicationRecord
  belongs_to :map
  default_scope -> { order(country_code: :asc) }
  validates :map_id, presence: true
  validates :country_code, presence: true,
                           length: { is: 2 },
                           uniqueness: { case_sensitive: false,
                                         scope: :map_id },
                           inclusion: { in: Map.country_codes }
end
