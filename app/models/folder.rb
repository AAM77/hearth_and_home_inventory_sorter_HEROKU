require_relative './concerns/item_folder_category_helpers.rb'

class Folder < ActiveRecord::Base
  extend ItemFolderCategoryHelpers::ClassMethods
  include ItemFolderCategoryHelpers::InstanceMethods

  belongs_to :user
  has_many :item_folders
  has_many :items, through: :item_folders

  validates_presence_of :name

end
