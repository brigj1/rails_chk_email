# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]
  before_action :authenticate_shopper!, only: [:destroy]

  def create
    @shopper = Shopper.authenticate_by(email: params[:shopper][:email].downcase, password: params[:shopper][:password])
    if @shopper
      if @shopper.unconfirmed?
        redirect_to new_confirmation_path, alert: "Incorrect email or password."
        # per https://github.com/stevepolitodesign/rails-authentication-from-scratch/pull/94 do:
        #redirect_to new_confirmation_path, alert: "Please confirm your email first."
      else
        after_login_path = session[:shopper_return_to] || root_path
        active_session = login @shopper
        remember(active_session) if params[:shopper][:remember_me] == "1"
        redirect_to after_login_path, notice: "Signed in."
      end
    else
      flash.now[:alert] = "Incorrect email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    forget_active_session
    logout
    redirect_to root_path, notice: "Signed out."
  end

  def new
  end

end
