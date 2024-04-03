# app/controllers/passwords_controller.rb
class PasswordsController < ApplicationController
  before_action :redirect_if_authenticated

  def create
    @shopper = Shopper.find_by(email: params[:shopper][:email].downcase)
    if @shopper.present?
      if @shopper.confirmed?
        @shopper.send_password_reset_email!
        redirect_to root_path, notice: "If that shopper exists we've sent instructions to their email."
      else
        redirect_to new_confirmation_path, alert: "Please confirm your email first."
      end
    else
      redirect_to root_path, notice: "If that shopper exists we've sent instructions to their email."
    end
  end

  def edit
    @shopper = Shopper.find_signed(params[:password_reset_token], purpose: :reset_password)
    if @shopper.present? && @shopper.unconfirmed?
      redirect_to new_confirmation_path, alert: "You must confirm your email before you can sign in."
    elsif @shopper.nil?
      redirect_to new_password_path, alert: "Invalid or expired token."
    end
  end

  def new
  end

  def update
    @shopper = Shopper.find_signed(params[:password_reset_token], purpose: :reset_password)
    if @shopper
      if @shopper.unconfirmed?
        redirect_to new_confirmation_path, alert: "You must confirm your email before you can sign in."
      elsif @shopper.update(password_params)
        redirect_to login_path, notice: "Sign in."
      else
        flash.now[:alert] = @shopper.errors.full_messages.to_sentence
        render :edit, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Invalid or expired token."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:shopper).permit(:password, :password_confirmation)
  end
end
