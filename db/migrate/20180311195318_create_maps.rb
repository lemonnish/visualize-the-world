class CreateMaps < ActiveRecord::Migration[5.1]
  def change
    create_table :maps do |t|
      t.string :title
      t.boolean :public, default: false
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :maps, [:user_id, :updated_at]
  end
end
