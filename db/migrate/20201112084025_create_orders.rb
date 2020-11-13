class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|

      t.bigint  :user_id
      t.bigint  :vehicle_id
      t.integer  :lock_version

      t.integer :status, default: 0

      t.decimal  :amount, :precision => 10, :scale => 2
      t.datetime :starts_at, precision: 6, null: false
      t.datetime :expires_at, precision: 6, null: false

      t.timestamps
    end
  end
end
