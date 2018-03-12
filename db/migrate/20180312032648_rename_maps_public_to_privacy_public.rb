class RenameMapsPublicToPrivacyPublic < ActiveRecord::Migration[5.1]
  def change
    rename_column :maps, :public, :privacy_public
  end
end
