class CreatePlacements < ActiveRecord::Migration
  def change
    create_table :placements do |t|
      t.references :order, index: true
      t.references :product, index: true

      t.timestamps null: false
    end
    add_foreign_key :placements, :orders, dependent: :delete
    add_foreign_key :placements, :products, dependent: :delete
  end
end
