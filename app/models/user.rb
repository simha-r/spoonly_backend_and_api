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
#  referral_code          :string(255)
#  device_id              :string(255)
#  promo_code_shown       :boolean
#  orders_count           :integer          default(0), not null
#  referrals_count        :integer          default(0), not null
#

class User < ActiveRecord::Base

  include UserPusher

  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable and :
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,:confirmable,:omniauthable

  delegate :name,:first_name,:phone_number,:phone_number_verified, to: :profile

  has_many :authorizations, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :orders
  has_one :profile, dependent: :destroy
  has_one :wallet, dependent: :destroy
  has_many :feedbacks

  has_many :referrals,foreign_key: :referrer_id
  has_one :referred,foreign_key: :referred_id,class_name: 'Referral'
  has_many :referred_users,through: :referrals,foreign_key: :referrer_id,source: :referred
  has_one :referrer_user,through: :referred,foreign_key: :referred_id,source: :referrer
  has_many :user_general_promotions
  has_many :general_promotions, through: :user_general_promotions

  has_many :user_locations
  has_many :locations,through: :user_locations

  attr_accessor :login_type

  before_create :generate_referral_code
  before_create :generate_authentication_token
  after_create :create_wallet
  before_save :ensure_authentication_token

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
      device_id = auth[:device_id]
      email = auth[:info][:email]
      name = auth[:info][:name]
      first_name = auth[:info][:first_name]
      last_name = auth[:info][:last_name]
      profile_url=auth[:info][:profile_link]
      pic_url = auth[:info][:pic_url]
      gender = auth[:info][:gender]
    else
      provider = auth.provider
      uid = auth.uid
      token = auth.credentials.token
      email = auth[:info][:email]
      name = auth.info.name
      first_name = auth.info.first_name
      last_name = auth.info.last_name
      profile_url =auth.info.urls[provider.capitalize] if auth.info.urls
      pic_url = auth[:info][:image]
      device_id = nil
      gender = auth[:info][:gender]
    end
    authorization = Authorization.where(:provider => provider, :uid => uid).first_or_initialize
    if authorization.user.blank?
      user = current_user || User.where('email = ?', email).first
      if user.blank?
        user = User.new
        user.password = Devise.friendly_token[0,10]
        user.create_profile(name: name,pic_url: pic_url,gender: gender,first_name: first_name,last_name: last_name)
        user.email = email
        user.device_id = device_id if device_id
        user.skip_confirmation!
        user.confirm! if user.save
        user.login_type='new_user'
      end
      # If user has been saved, save authorization
      if authorization.user_id = user.id
        authorization.profile_url=profile_url
        authorization.save
      end
    else
      user = authorization.user
      # Dont update if device id is nil..it could mean he logged in from browser
      user.update_attributes(device_id: device_id) if device_id
      user.login_type='old_user'
    end
    user
  end

  def mark_number_verified
    profile.update_attributes(phone_number_verified: true)
  end

  def mark_number_unverified
    profile.update_attributes(phone_number_verified: false)
  end

  def update_number phone_number
    profile.update_attributes(phone_number: phone_number)
  end

  def add_to_wallet amount,payment_id,payment_gateway
    create_wallet if !wallet
    wallet.add_card_amount amount,payment_id,payment_gateway
  end

  def apply_wallet_promotion wallet_promotion
    wallet.apply_promotion wallet_promotion
  end

  def has_been_referred?
    if device_id.present?
      # Has this device id  been used to redeem a referral code before ?
      users = User.where(device_id: device_id)
      referral = Referral.where(referred_id: users).first
      if referral
        true
      else
        false
      end
    else
      referred
    end
  end

  def trying_to_refer_self? referral_code
    if device_id.present?
      # Has this device id  been used to redeem a referral code before ?
      users = User.where(device_id: device_id)
      referral_codes = users.collect(&:referral_code)
      if referral_codes.include? referral_code
        true
      else
        false
      end
    else
      false
    end
  end

  def refer_user user
    general_promotions = GeneralPromotion.all
    if((user.has_been_referred?) || (user.trying_to_refer_self?(referral_code)) || (user.orders.delivered.present?) || (user.referral_code==referral_code) || GeneralPromotion.applied_for?(user,general_promotions) || (referrer_user==user))
      return false
    end
    referral = referrals.create!(referred_id: user.id)
    #TODO Write reward logic here or in before/after hooks of referral
  end

  def serializable_hash(options={})
    options||={}
    options[:except]=[:created_at,:updated_at,:promo_code_shown]
    options[:include] = :profile
    options[:methods]=[:login_type]
    super
  end

  def transactions
    (wallet.debits + wallet.credits).sort_by &:created_at
  end

  def update_device_id android_id,telephony_manager_device_id
    device_id = android_id.present? ? android_id : telephony_manager_device_id
    update_attributes(device_id: device_id)
  end

  def log_location lat,long
    last_seen = Time.now
    last_location = locations.last
    if (!last_location || (last_location.distance_from(lat.to_f,long.to_f) > 0.1))
      location= Location.create(latitude: lat.to_f,longitude: long.to_f)
    else
      location = last_location
    end

    if location.persisted?
      user_locations.create(last_seen: last_seen,location: location)
    end
  rescue Exception => e
    HealthyLunchUtils.log_error e.message,e
  end

  handle_asynchronously :log_location,queue: 'log_locations',priority: '6'


  def cashback_for_customer_satisfaction wallet_promotion_name,custom_message
    wallet_promotion=WalletPromotion.manual.where(name: wallet_promotion_name).first
    if wallet.apply_promotion wallet_promotion
      message = custom_message || "Dear #{name.split(' ')[0]}, Apologies for the subpar service.We've gone ahead and refunded Rs #{wallet_promotion.amount}  into your Spoonly wallet."
      notify_wallet message,"Refunds@Spoonly"
      UserMessenger.apologise self,message
    end
  end



  def self.search wildcard,referred_by
    users = all
    if wildcard.present?
      wildcard_search = "%#{wildcard}%"
      users = where("email iLIKE ?", wildcard_search)
    end
    if referred_by.present?
      users = users.get_all_referred_by referred_by
    end
    users
  end

  def self.get_all_referred_by user_email
    result = []
    referrer = User.where(email: user_email).first
    if referrer
      referrals = Referral.where(referrer_id: referrer.id)
      if referrals.present?
        result = where(id: referrals.collect(&:referred_id))
      else
        result = all
      end
    else
      result = all
    end
    result
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

  def generate_referral_code
    self.referral_code = loop do
      random_token = ("rc"+rand(36**4).to_s(36)).upcase
      break random_token unless self.class.exists?(referral_code: random_token)
    end
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

end
