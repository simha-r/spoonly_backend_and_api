class AddOtpBackupCodesToCompanyUser < ActiveRecord::Migration
  def change
    add_column :company_users, :otp_backup_codes, :string, array: true
  end
end
