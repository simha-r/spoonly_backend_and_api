class Company::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  skip_before_filter :authenticate_company_user!

  def all
    p env["omniauth.auth"]
    user = CompanyUser.from_omniauth(env["omniauth.auth"], current_user)
    if user.persisted?
      user.confirm!
      flash[:notice] = "You are in..!!! Go to edit profile to see the status for the accounts"
      sign_in_and_redirect(user)
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to root_path,alert: 'Unable to login !'
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
