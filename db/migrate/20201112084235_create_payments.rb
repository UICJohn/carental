class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.decimal :amount

      t.bigint  :order_id
      t.bigint  :user_id

      t.integer :platform, default: 0

      t.timestamps
    end
  end
end
