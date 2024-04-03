class AddUnconfirmedEmailToShoppers < ActiveRecord::Migration[7.1]
  def change
    add_column :shoppers, :unconfirmed_email, :string
  end
end
