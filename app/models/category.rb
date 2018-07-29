require_relative './concerns/item_folder_category_helpers.rb'

class Category < ActiveRecord::Base
  extend ItemFolderCategoryHelpers::ClassMethods
  include ItemFolderCategoryHelpers::InstanceMethods

  belongs_to :user
  has_many :item_categories
  has_many :items, through: :item_categories

  validates_presence_of :name

end
