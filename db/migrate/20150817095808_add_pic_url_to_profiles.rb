class AddPicUrlToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :pic_url, :string
  end
end
