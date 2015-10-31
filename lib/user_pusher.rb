module UserPusher

  def ask_for_feedback message=nil,title=nil
    message ||= "Dear #{name.split(' ')[0]}, Would you like to rate your meal? We would love to hear of any suggestions that you have"
    PushProvider.push self,message,"FeedbackActivity",title
  end

  def notify_menu message,title
    PushProvider.push self,message,nil,title
  end

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

end