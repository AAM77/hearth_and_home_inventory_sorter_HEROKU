require_relative './concerns/item_folder_category_helpers.rb'

class Item < ActiveRecord::Base
  extend ItemFolderCategoryHelpers::ClassMethods
  include ItemFolderCategoryHelpers::InstanceMethods

  belongs_to :user
  has_many :item_folders
  has_many :item_categories
  has_many :folders, through: :item_folders
  has_many :categories, through: :item_categories

  validates_presence_of :name

end
