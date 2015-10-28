# == Schema Information
#
# Table name: authorizations
#
#  id          :integer          not null, primary key
#  provider    :string(255)
#  uid         :string(255)
#  user_id     :integer
#  token       :string(255)
#  username    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  profile_url :string(255)
#

class Authorization < ActiveRecord::Base
  belongs_to :user

  after_create :fetch_details



  def fetch_details
    self.send("fetch_details_from_#{self.provider.downcase}")
  end


  def fetch_details_from_facebook
=begin
    graph = Koala::Facebook::API.new(self.token)
    facebook_data = graph.get_object("me")
    self.username = facebook_data['username']
    self.save
=end
  end

  def fetch_details_from_google

  end

end
