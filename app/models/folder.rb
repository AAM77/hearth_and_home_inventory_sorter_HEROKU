class Location < ActiveRecord::Base
  belongs_to :user
  has_many :item_folders
  has_many :items, through: :item_folder
end
