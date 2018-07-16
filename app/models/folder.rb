class Folder < ActiveRecord::Base
  belongs_to :user
  has_many :item_folders
  has_many :items, through: :item_folders

  #def initialize(name: "New Folder")
    # Edit this so that if a name is not specified,
    # the folder is created with a default name of "New Folder"
  #end

  def slug
    self.name.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    self.all.find {|s| s.slug == slug}
  end
end
