class CreateVehicles < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicles do |t|
      t.bigint  :model_id
      t.bigint  :store_id

      t.integer  :lock_version

      t.decimal :price, :precision => 10, :scale => 2

      t.integer :amount, default: 0

      t.string  :color

      t.boolean :active, default: true

      t.timestamps
    end
  end
end
