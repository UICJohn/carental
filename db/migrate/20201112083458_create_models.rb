class CreateModels < ActiveRecord::Migration[6.0]
  def change
    create_table :models do |t|
      t.bigint  :brand_id
      t.string  :name
      t.boolean :active, default: true
      t.string  :year
      t.timestamps
    end
  end
end
