module UserPusher

  def ask_for_feedback message=nil
    message ||= "Dear #{name.split(' ')[0]}, Would you like to rate your meal? We would love to hear of any suggestions that you have"
    PushProvider.push self,message,"FeedbackActivity"
  end

  def notify_menu message
    PushProvider.push self,message,nil
  end

end