# app/controllers/concerns/authentication.rb
module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :current_shopper
    helper_method :current_shopper
    helper_method :shopper_signed_in?
  end

  def authenticate_shopper!
    store_location
    redirect_to login_path, alert: "You need to login to access that page." unless shopper_signed_in?
  end

  def login(shopper)
    reset_session
    session[:current_shopper_id] = shopper.id
  end

  def remember(shopper)
    shopper.regenerate_remember_token
    cookies.permanent.encrypted[:remember_token] = shopper.remember_token
  end

  def logout
    reset_session
  end

  def forget(shopper)
    cookies.delete :remember_token
    shopper.regenerate_remember_token
  end

  def redirect_if_authenticated
    redirect_to root_path, alert: "You are already logged in." if shopper_signed_in?
  end

  private

  def current_shopper
    Current.shopper ||= if session[:current_shopper_id].present?
      Shopper.find_by(id: session[:current_shopper_id])
    elsif cookies.permanent.encrypted[:remember_token].present?
      Shopper.find_by(remember_token: cookies.permanent.encrypted[:remember_token])
    end
  end

  def shopper_signed_in?
    Current.shopper.present?
  end

  def store_location
    session[:shopper_return_to] = request.original_url if request.get? && request.local?
  end

end

