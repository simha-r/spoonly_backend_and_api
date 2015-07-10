# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  created_at             :datetime
#  updated_at             :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  authentication_token   :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable and :
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:confirmable,:omniauthable

  has_many :authorizations
  has_many :addresses
  has_many :orders
  has_one :profile
  has_one :wallet


  before_save :ensure_authentication_token

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end


  def self.new_with_session(params,session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"],without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def self.from_omniauth(auth, current_user)
    if auth.class==Hash
      provider = auth[:provider]
      uid = auth[:uid]
      token = auth[:access_token]
      email = auth[:info][:email]
    else
      provider = auth.provider
      uid = auth.uid
      token = auth.credentials.token
      email = auth["info"]["email"]
    end

    authorization = Authorization.where(:provider => provider, :uid => uid).first_or_initialize
    if authorization.user.blank?
      user = current_user || User.where('email = ?', email).first
      if user.blank?
        user = User.new
        user.password = Devise.friendly_token[0,10]
        #TODO Put name in profile
        # user.name = auth.info.name
        user.email = email
        user.save
      end
      authorization.user_id = user.id
      authorization.save
    else
      user = authorization.user
    end
    user
  end


  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

end
