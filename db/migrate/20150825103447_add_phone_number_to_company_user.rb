class AddPhoneNumberToCompanyUser < ActiveRecord::Migration
  def change
    add_column :company_users, :phone_number, :string
  end
end
