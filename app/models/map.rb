class Map < ApplicationRecord
  belongs_to :user
  has_many :map_contents, dependent: :destroy
  default_scope -> { order(updated_at: :desc) }
  validates :user_id, presence: true
  validates :title, presence: true

  # returns an array of all valid country codes
  def self.country_codes
    ISO3166::Country.codes
  end

  # returns true if country code is valid
  def self.is_country_code?(string)
    ISO3166::Country.codes.include?(string)
  end

  # return the name of the country based on the alpha-2 country code
  def self.get_name_from_country_code(string)
    ISO3166::Country.new(string).name
  end

  # return the name and local country name based on the  alpha-2 country code
  def self.get_ext_name_from_country_code(string)
    country = ISO3166::Country.new(string)
    Map.get_ext_name_from_country(country)
  end

  def self.get_ext_name_from_country(country)
    name = [ country.name ]

    if local = country.local_name then
      name.push(local) if !name.include?(local)
    end
    
    return name
  end

  def self.get_region_name_from_country(country)
    region_name = []
    exclude_list = [country.continent]

    if (region = country.region) && !region.blank? then
      region_name.push(region) if !exclude_list.include?(region)
      exclude_list.push(region)
    end
    if (subregion = country.subregion) && !subregion.blank? then
      region_name.push(subregion) if !exclude_list.include?(subregion)
    end

    return region_name
  end

  # get the country num-3 code that matches the alpha-2 code
  def self.convert_country_code_alpha_to_num(string)
    ISO3166::Country.new(string).number
  end

  # returns an array of all SVG id's for selected countries
  def get_selected_ids
    map_contents.all.map{ |m| "#country-#{ Map.convert_country_code_alpha_to_num(m.country_code) }" }
  end

  def get_selected_codes
    map_contents.all.map{ |m| m.country_code }
  end

  def get_selected_nums
    map_contents.all.map{ |m| Map.convert_country_code_alpha_to_num(m.country_code) }
  end

  # returns an array of all country_codes not currently in use
  def get_remaining_codes
    Map.country_codes - get_selected_codes
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
