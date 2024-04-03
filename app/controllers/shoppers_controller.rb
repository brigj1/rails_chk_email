# app/controllers/shoppers_controller.rb
class ShoppersController < ApplicationController

  def create
    @shopper = Shopper.new(shopper_params)
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

  private

  def shopper_params
    params.require(:shopper).permit(:email, :password, :password_confirmation)
  end
end
