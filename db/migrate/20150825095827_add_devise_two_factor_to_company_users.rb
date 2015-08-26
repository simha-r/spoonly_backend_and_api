class AddDeviseTwoFactorToCompanyUsers < ActiveRecord::Migration
  def change
    add_column :company_users, :encrypted_otp_secret, :string
    add_column :company_users, :encrypted_otp_secret_iv, :string
    add_column :company_users, :encrypted_otp_secret_salt, :string
    add_column :company_users, :otp_required_for_login, :boolean
  end
end
