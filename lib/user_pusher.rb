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

end