class CreateMapContents < ActiveRecord::Migration[5.1]
  def change
    create_table :map_contents do |t|
      t.string :country_code
      t.text :comment
      t.references :map, foreign_key: true

      t.timestamps
    end
    add_index :map_contents, [:map_id, :country_code]
  end
end
