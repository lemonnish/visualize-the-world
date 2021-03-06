class MapContent < ApplicationRecord
  belongs_to :map
  default_scope -> { order(country_code: :asc) }
  validates :map_id, presence: true
  validates :country_code, presence: true,
                           length: { is: 2 },
                           uniqueness: { case_sensitive: false,
                                         scope: :map_id }
  validate :exists_in_country_list

  def country_name
    Map.get_name_from_country_code(country_code)
  end
  
  def ext_country_name
    Map.get_ext_name_from_country_code(country_code)
  end

  private

  # Verify that the country_code (lowercase) is in the
  # list of allowed countries
  def exists_in_country_list
    country_code.upcase!
    if !Map.is_country_code?(country_code)
      errors.add(:country_code, "is not in the list of allowed countries")
    end
  end
end
