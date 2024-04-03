class CreateShoppers < ActiveRecord::Migration[7.1]
  def change
    create_table :shoppers do |t|
      t.string :email, null: false

      t.timestamps
    end

    add_index :shoppers, :email, unique: true
  end
end
