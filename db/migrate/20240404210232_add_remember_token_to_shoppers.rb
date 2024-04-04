# db/migrate/[timestamp]_add_remember_token_to_shoppers.rb
class AddRememberTokenToShoppers < ActiveRecord::Migration[7.1]
  def change
    add_column :shoppers, :remember_token, :string, null: false
    add_index  :shoppers, :remember_token, unique: true
  end
end
