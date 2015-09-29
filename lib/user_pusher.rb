module UserPusher

  def ask_for_feedback message
    message ||= "Dear #{name}, Would you like to rate your meal? We would love to hear of any suggestions that you have"
    PushProvider.push self,message,"FeedbackActivity"
  end

end