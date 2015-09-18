# == Schema Information
#
# Table name: profiles
#
#  id                                    :integer          not null, primary key
#  name                                  :string(255)
#  phone_number                          :string(255)
#  phone_number_verified                 :boolean          default(FALSE)
#  user_id                               :integer
#  created_at                            :datetime
#  updated_at                            :datetime
#  phone_number_verification_code        :string(255)
#  phone_number_verify_tries             :integer
#  pic_url                               :string(255)
#  number_verification_code_generated_at :datetime
#

class Profile < ActiveRecord::Base
  belongs_to :user

  before_save :check_phone_number_changed

  def serializable_hash(options={})
    options||={}
    options[:except]=[:created_at,:updated_at,:user_id,:id]
    super
  end

  def check_phone_number_changed
    if phone_number_changed?
      if phone_number_verified==false
        return
      end
      puts "Phone number has changed"
      user.mark_number_unverified
    end
  end


  def first_name
    if name
      name.split(" ")[0]
    end
  end

end
