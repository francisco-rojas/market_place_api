class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title, default: ''
      t.decimal :price, default: 0.0
      t.boolean :published, default: false
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :products, :user_id
    # see https://robots.thoughtbot.com/referential-integrity-with-foreign-keys
    add_foreign_key :products, :users, dependent: :delete
  end
end
