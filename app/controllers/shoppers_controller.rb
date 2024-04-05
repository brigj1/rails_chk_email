# app/controllers/shoppers_controller.rb
class ShoppersController < ApplicationController
  before_action :authenticate_shopper!, only: [:edit, :destroy, :update]
  before_action :redirect_if_authenticated, only: [:create, :new]

  def create
    @shopper = Shopper.new(create_shopper_params)
    if @shopper.save
      @shopper.send_confirmation_email!
      redirect_to root_path, notice: "Please check your email for confirmation instructions."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def new
    @shopper = Shopper.new
  end

  def edit
    @shopper = current_shopper
    @active_sessions = @shopper.active_sessions.order(created_at: :desc)
  end

  def update
    @shopper = current_shopper
    @active_sessions = @shopper.active_sessions.order(created_at: :desc)

    if @shopper.authenticate(params[:shopper][:current_password])
      if @shopper.update(update_shopper_params)
        if params[:shopper][:unconfirmed_email].present?
          @shopper.send_confirmation_email!
          redirect_to root_path, notice: "Check your email for confirmation instructions."
        else
          redirect_to root_path, notice: "Account updated."
        end
      else
        render :edit, status: :unprocessable_entity
      end
    else
      flash.now[:error] = "Incorrect password"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    current_shopper.destroy
    reset_session
    redirect_to root_path, notice: "Your account has been deleted."
  end

  private

  def create_shopper_params
    params.require(:shopper).permit(:email, :password, :password_confirmation)
  end

  def update_shopper_params
    params.require(:shopper).permit(:current_password, :password, :password_confirmation, :unconfirmed_email)
  end
end
