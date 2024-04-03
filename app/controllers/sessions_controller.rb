# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]

  def create
    @shopper = Shopper.find_by(email: params[:shopper][:email].downcase)
    if @shopper
      if @shopper.unconfirmed?
        redirect_to new_confirmation_path, alert: "Incorrect email or password."
      elsif @shopper.authenticate(params[:shopper][:password])
        login @shopper
        redirect_to root_path, notice: "Signed in."
      else
        flash.now[:alert] = "Incorrect email or password."
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Incorrect email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "Signed out."
  end

  def new
  end

end
