class RemovePhoneNumberVerificationReqIdFromProfiles < ActiveRecord::Migration
  def change
    remove_column :profiles,:phone_number_verification_req_id
  end
end
