class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|

      t.bigint  :user_id
      t.bigint  :payment_id
      t.bigint  :vehicle_id

      t.decimal  :amount, :precision => 10, :scale => 2
      t.datetime :start_at
      t.datetime :expires_at

      t.timestamps
    end
  end
end
