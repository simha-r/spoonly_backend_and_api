class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :overall_rating
      t.string :comment
      t.references :user

      t.timestamps
    end
  end
end
