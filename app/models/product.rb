# == Schema Information
#
# Table name: products
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  desc               :string(255)
#  price              :float
#  created_at         :datetime
#  updated_at         :datetime
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  vegetarian         :boolean          default(FALSE)
#  long_description   :string(255)
#  cost_description   :text
#

class Product < ActiveRecord::Base

  has_attached_file :photo,:convert_options => { :mobile => "-strip -quality 45" },
                    :styles => { :medium => "300x300", :mobile => "800*520",:thumb=>"100*100" },
                    :default_url => "/images/:style/missing.png",processors: [:thumbnail]
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/


  SERVING_RADIUS = 5
  CIRCLE_CENTRE_LAT = 17.462637
  CIRCLE_CENTRE_LONG=78.373031

  def make_active
    update_attributes(state: 'active')
  end

  def serializable_hash(options={})
    options ||={}
    options[:methods] = [:photo_url]
    options[:except]=[:cost_description]
    super
  end

  def photo_url
    photo.url :mobile
  end

  def category
    vegetarian? ? 'VEG' : 'NONVEG'
  end
end
