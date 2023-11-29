class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :status
      t.integer :user_id
      t.decimal :total_price
      t.string :guest_id

      t.timestamps
    end
  end
end
