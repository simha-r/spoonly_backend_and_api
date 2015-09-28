class Customer::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  skip_before_filter :authenticate_user!

  def all
    p env["omniauth.auth"]
    user = User.from_omniauth(env["omniauth.auth"], current_user)
    if user.persisted?
      user.confirm!
      session[:login_type]=user.login_type
      sign_in_and_redirect(user)
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end

  def failure
    #handle you logic here..
    #and delegate to super.
    super
  end


  alias_method :facebook, :all
  alias_method :twitter, :all
  alias_method :linkedin, :all
  alias_method :github, :all
  alias_method :passthru, :all
  alias_method :google, :all
end
