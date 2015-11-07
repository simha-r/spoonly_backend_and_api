class ChangeFeedbackColumnTypeToText < ActiveRecord::Migration
  def change
    change_column :feedbacks, :comment, :text
  end
end
