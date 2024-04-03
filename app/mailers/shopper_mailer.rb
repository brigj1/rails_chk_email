# app/mailers/shopper_mailer.rb
class ShopperMailer < ApplicationMailer
  default from: Shopper::MAILER_FROM_EMAIL

  def confirmation(shopper, confirmation_token)
    @shopper = shopper
    @confirmation_token = confirmation_token

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.shopper_mailer.confirmation.subject
    #
    mail to: @shopper.email, subject: "Confirmation Instructions"
  end

  def password_reset(shopper, password_reset_token)
    @shopper = shopper
    @password_reset_token = password_reset_token

    mail to: @shopper.email, subject: "Password Reset Instructions"
  end

end
