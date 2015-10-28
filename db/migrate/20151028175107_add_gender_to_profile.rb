class AddGenderToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :gender, :string
  end
end
