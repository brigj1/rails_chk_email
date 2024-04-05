# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]
  before_action :authenticate_shopper!, only: [:destroy]

  def create
    @shopper = Shopper.authenticate_by(email: params[:shopper][:email].downcase, password: params[:shopper][:password])
    if @shopper
      if @shopper.unconfirmed?
        redirect_to new_confirmation_path, alert: "Incorrect email or password."
      else
        after_login_path = session[:shopper_return_to] || root_path
        login @shopper
        remember(@shopper) if params[:shopper][:remember_me] == "1"
        redirect_to after_login_path, notice: "Signed in."
      end
    else
      flash.now[:alert] = "Incorrect email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    forget(current_shopper)
    logout
    redirect_to root_path, notice: "Signed out."
  end

  def new
  end

end
