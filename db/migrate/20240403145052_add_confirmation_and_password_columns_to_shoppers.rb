class AddConfirmationAndPasswordColumnsToShoppers < ActiveRecord::Migration[7.1]
  def change
    add_column :shoppers, :confirmed_at, :datetime
    add_column :shoppers, :password_digest, :string
  end
end
