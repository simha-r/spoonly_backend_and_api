require 'parse-ruby-client'

module PushProvider
  #PARSE Docs https://github.com/adelevie/parse-ruby-client/tree/v0.3.0
  def self.push_using_parse user,message,activity,title
    data = { :alert => message }
    data[:activity] = activity if activity.present?
    data[:title] = title if title.present?
    push = Parse::Push.new(data, "user_#{user.id}")
    push.type = "android"
    push.save
  end

  def self.push user,message,activity,title=nil 
    push_using_parse user,message,activity,title
  end


end