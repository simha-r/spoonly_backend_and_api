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

  delegate :name,:phone_number,:phone_number_verified, to: :profile

  has_many :authorizations, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :orders
  has_one :profile, dependent: :destroy
  has_one :wallet, dependent: :destroy
  has_many :feedbacks


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
      name = auth[:info][:name]
      pic_url = auth[:info][:pic_url]
    else
      provider = auth.provider
      uid = auth.uid
      token = auth.credentials.token
      email = auth[:info][:email]
      name = auth.info.name
      pic_url = auth[:info][:image]
    end
    authorization = Authorization.where(:provider => provider, :uid => uid).first_or_initialize
    if authorization.user.blank?
      user = current_user || User.where('email = ?', email).first
      if user.blank?
        user = User.new
        user.password = Devise.friendly_token[0,10]
        user.create_profile(name: name,pic_url: pic_url)
        user.email = email
        user.skip_confirmation!
        user.confirm! if user.save
      end
      authorization.save if authorization.user_id = user.id
    else
      user = authorization.user
    end
    user
  end


  def serializable_hash(options={})
    options ||={}
    options[:include] = :profile
    super
  end

  def mark_number_verified
    profile.update_attributes(phone_number_verified: true)
  end

  def update_number phone_number
    profile.update_attributes(phone_number: phone_number)
  end

  def add_to_wallet amount,payment_id,payment_gateway
    create_wallet if !wallet
    wallet.add_card_amount amount,payment_id,payment_gateway
  end

  def serializable_hash(options={})
    options||={}
    options[:except]=[:created_at,:updated_at]
    super
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

end
