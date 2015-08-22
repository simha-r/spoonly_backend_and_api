module CurrentCart
  extend ActiveSupport::Concern

  private

  def set_cart
    @cart = Cart.find(session[:cart_id])
    if !@cart.expiry_time
      @cart.destroy
      raise 'Invalid Expiry time for cart'
    end
    if @cart.expired?
      @cart.destroy
      raise 'Cart Expired'
    end

  rescue Exception=>e
    @cart = Cart.create
    session[:cart_id] = @cart.id
  end
end
