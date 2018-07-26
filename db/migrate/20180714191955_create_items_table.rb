class CreateItemsTable < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.decimal :cost, precision: 30, scale: 2
      t.integer :user_id
    end
  end
end
