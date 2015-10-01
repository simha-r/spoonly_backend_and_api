# == Schema Information
#
# Table name: user_general_promotions
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  general_promotion_id :integer
#  created_at           :datetime
#  updated_at           :datetime
#

class UserGeneralPromotion < ActiveRecord::Base
  belongs_to :user
  belongs_to :general_promotion
end
