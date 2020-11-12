class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.decimal :amount

      t.integer :type, default: 0

      t.timestamps
    end
  end
end
