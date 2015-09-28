class Api::V1::PromotionsController < Api::V1::BaseController

  before_action :authenticate_user!

  def referral
    referral_code = current_user.referral_code
    share_text = "Use my Spoonly Promo Code #{referral_code} and get Rs 50 in your wallet. Download the app - https://play.google.com/apps/testing/com.freshspoon.spoonly"
    render json: {show_text: "Know anyone in or near Mindspace,CtrlS or TCS Synergy Park ?
Share your promo code with them.
Your friend gets Rs 50,you get Rs 50 after they order!", share_text: share_text,referral_code: referral_code}
  end

end