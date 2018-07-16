class CreateItemsTable < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.integer :cost
      t.integer :user_id
    end
  end
end
