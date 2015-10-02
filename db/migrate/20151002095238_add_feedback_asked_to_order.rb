class AddFeedbackAskedToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :feedback_asked, :boolean,default: false
  end
end
