class AddNumberVerificationCodeGeneratedAtToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :number_verification_code_generated_at, :datetime
  end
end
