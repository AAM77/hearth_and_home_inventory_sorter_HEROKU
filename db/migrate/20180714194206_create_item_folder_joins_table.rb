class CreateItemFolderJoinsTable < ActiveRecord::Migration
  def change
    create_table :item_folders do |t|
      t.integer :item_id
      t.integer :folder_id
    end
  end
end
