# == Schema Information
#
# Table name: company_users
#
#  id                        :integer          not null, primary key
#  created_at                :datetime
#  updated_at                :datetime
#  email                     :string(255)      default(""), not null
#  encrypted_password        :string(255)      default(""), not null
#  reset_password_token      :string(255)
#  reset_password_sent_at    :datetime
#  remember_created_at       :datetime
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :string(255)
#  last_sign_in_ip           :string(255)
#  encrypted_otp_secret      :string(255)
#  encrypted_otp_secret_iv   :string(255)
#  encrypted_otp_secret_salt :string(255)
#  otp_required_for_login    :boolean
#  phone_number              :string(255)
#

class CompanyUser < ActiveRecord::Base
  devise :two_factor_authenticatable,:two_factor_backupable,
         :otp_secret_encryption_key=>ENV['DEVISE_ENCRYPTION_KEY'], otp_secret_length: 16

  devise :recoverable, :rememberable, :trackable, :validatable

  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable


  #Send the current_otp to the users sim

  def enable_otp
    self.otp_secret = CompanyUser.generate_otp_secret
    self.otp_required_for_login = true
    puts otp_secret
    save!
  end

  def disable_otp
    self.otp_secret = CompanyUser.generate_otp_secret
    self.otp_required_for_login = true
    save!
  end

  def refresh_backup_codes
    codes = generate_otp_backup_codes!
    puts "Codes are "+codes.inspect
    save!
    codes
  end



end
