# == Schema Information
#
# Table name: feedbacks
#
#  id             :integer          not null, primary key
#  overall_rating :integer
#  comment        :text
#  user_id        :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Feedback < ActiveRecord::Base

  belongs_to :user

end
