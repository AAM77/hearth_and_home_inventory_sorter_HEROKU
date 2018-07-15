class Location < ActiveRecord::Base
  belongs_to :user
  has_many :item_folders
  has_many :items, through: :item_folder

  #def initialize(name: "New Folder")
    # Edit this so that if a name is not specified,
    # the folder is created with a default name of "New Folder"
  #end
end
