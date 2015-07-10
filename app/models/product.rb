# == Schema Information
#
# Table name: products
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  desc               :string(255)
#  price              :float
#  category_id        :integer
#  created_at         :datetime
#  updated_at         :datetime
#  state              :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#

class Product < ActiveRecord::Base

  belongs_to :category

  scope :active, ->{where(state: 'active')}
  scope :inactive, ->{where(state: 'inactive')}

  VALID_STATES = ['active','inactive']

  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" },
                    :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/



  def make_active
    update_attributes(state: 'active')
  end

end
