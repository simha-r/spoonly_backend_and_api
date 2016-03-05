module UserPusher

  def ask_for_feedback message=nil,title=nil
    message ||= "Dear #{name.split(' ')[0]}, Would you like to rate your meal? We would love to hear of any suggestions that you have"
    PushProvider.push self,message,"FeedbackActivity",title
  end

  def notify_menu message,title
    PushProvider.push self,message,nil,title
  end

  handle_asynchronously :notify_menu

  def notify_wallet message,title
    PushProvider.push self,message,"WalletActivity",title
  end

#   Non Essential methods
  def notify_general_promotion general_promotion
    title = "Rs #{general_promotion.amount} in your pocket!"
    message = "Welcome #{name.split(' ')[0]}! Rs #{general_promotion.amount} has been credited to your Spoonly wallet. We hope you enjoy your meal!"
    PushProvider.push self,message,"WalletActivity",title
  end

  def notify_share message,title
    PushProvider.push self,message,"ShareActivity",title
  end

  def notify_promotion_screen
    title = "Free Meals @ Spoonly"
    message = "Welcome #{name.split(' ')[0]}! If you have a Spoonly promo code,Tap here to enter it and get free meals"
    PushProvider.push self,message,"PromotionsActivity",title
  end

end