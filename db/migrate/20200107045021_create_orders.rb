class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :product
      t.string :brand
      t.integer :amount

      t.timestamps
    end
  end
end
