class AddExampleMapToMaps < ActiveRecord::Migration[5.1]
  def change
    add_column :maps, :example_map, :boolean, default: false
  end
end
