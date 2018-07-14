class Item < ActiveRecord::Base
  belongs_to :user
  has_many :item_folders
  has_many :item_categories
  has_many :folders, through: :item_folder
  has_many :categories, through: :item_category
end
