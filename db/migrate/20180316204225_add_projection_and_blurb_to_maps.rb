class AddProjectionAndBlurbToMaps < ActiveRecord::Migration[5.1]
  def change
    add_column :maps, :projection, :string, default: "geoAirocean"
    add_column :maps, :blurb, :text
  end
end
