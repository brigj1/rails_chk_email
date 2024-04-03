# Preview all emails at http://localhost:3000/rails/mailers/shopper_mailer
class ShopperMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/shopper_mailer/confirmation
  def confirmation
    ShopperMailer.confirmation
  end

end
