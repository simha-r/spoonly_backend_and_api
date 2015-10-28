class AddProfileUrlToAuthorizations < ActiveRecord::Migration
  def change
    add_column :authorizations, :profile_url, :string
  end
end
