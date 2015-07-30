class AddPhoneNumberVerificationCodeAndPhoneNumberTriesToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :phone_number_verification_code, :string
    add_column :profiles, :phone_number_verify_tries, :integer
  end
end
