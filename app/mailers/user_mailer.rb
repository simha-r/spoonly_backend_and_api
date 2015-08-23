class UserMailer < ActionMailer::Base
  default from: "orders@spoonly.in"

  def order_success order
    @order = order
    @user = @order.user
    subject = 'Your order has been confirmed'
    mail(to: @user.email,subject: subject)
  end

  def order_cancel order
    @order = order
    @user = @order.user
    subject = 'Your order has been cancelled'
    mail(to: @user.email,subject: subject)
  end


end
