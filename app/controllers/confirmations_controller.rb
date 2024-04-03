# app/controllers/confirmations_controller.rb
class ConfirmationsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]

  def create
    @shopper = Shopper.find_by(email: params[:shopper][:email].downcase)

    if @shopper.present? && @shopper.unconfirmed?
      @shopper.send_confirmation_email!
      redirect_to root_path, notice: "Check your email for confirmation instructions."
    else
      redirect_to new_confirmation_path, alert: "We could not find a shopper with that email or that email has already been confirmed."
    end
  end

  def edit
    @shopper = Shopper.find_signed(params[:confirmation_token], purpose: :confirm_email)

    if @shopper.present?
      if @shopper.confirm!
        login @shopper
        redirect_to root_path, notice: "Your account has been confirmed."
      else
        redirect_to new_confirmation_path, alert: "Something went wrong."
      end
    else
      redirect_to new_confirmation_path, alert: "Invalid token."
    end
  end

  def new
    @shopper = Shopper.new
  end

end
