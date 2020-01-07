class CreateHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :histories do |t|
      t.string :order_code
      t.string :brand
      t.string :product
      t.integer :amount

      t.timestamps
    end
  end
end
