class Api::V1::PromotionsController < Api::V1::BaseController

  before_action :authenticate_user!

  def referral
    referral_code = current_user.referral_code
    referral_link = "http://www.spoonly.in/gifts/#{referral_code}"
    # share_text = "Use my Spoonly Promo Code #{referral_code} and get Rs 50 in your wallet. Download the app at #{referral_link}"
    share_text = "Free meal with Spoonly - Spoonly is the fresh food button on your phone. Get Rs 50 meal credit using my link  #{referral_link}"

    render json: {show_text: "Good food must be shared ! Gift friends a free meal worth Rs 50 and earn Rs 50 when they order",share_text: share_text,referral_code: referral_code}
  end

end