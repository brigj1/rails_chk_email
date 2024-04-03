# app/controllers/concerns/authentication.rb
module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :current_shopper
    helper_method :current_shopper
    helper_method :shopper_signed_in?
  end

  def login(shopper)
    reset_session
    session[:current_shopper_id] = shopper.id
  end

  def logout
    reset_session
  end

  def redirect_if_authenticated
    redirect_to root_path, alert: "You are already logged in." if shopper_signed_in?
  end

  private

  def current_shopper
    Current.shopper ||= session[:current_shopper_id] && Shopper.find_by(id: session[:current_shopper_id])
  end

  def shopper_signed_in?
    Current.shopper.present?
  end

end

