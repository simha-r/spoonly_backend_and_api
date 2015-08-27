class CreateRefunds < ActiveRecord::Migration
  def change
    create_table :refunds do |t|
      t.string :description
      t.string :name

      t.timestamps
    end
  end
end
