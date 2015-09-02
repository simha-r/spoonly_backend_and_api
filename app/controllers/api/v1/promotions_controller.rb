class Api::V1::PromotionsController < Api::V1::BaseController

  before_action :authenticate_user!

  def referral
    render json: {show_text: "Share your promo code with a friend. Your friend gets Rs 50, you get Rs 50 when they order!", share_text:'get Rs 50 in your wallet. Download the app - http://spoonly.in'}
  end

end