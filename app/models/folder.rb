class Folder < ActiveRecord::Base
  belongs_to :user
  has_many :item_folders
  has_many :items, through: :item_folders

  validates_presence_of :name

  def slug
    self.name.gsub(" ", "-")
  end

  def self.find_by_folder_slug(slug, user_id)
    self.all.find {|s| s.slug == slug && s.user_id == user_id}
  end

  #######################################################
  # Test to see if the input folder name already exists #
  #######################################################
  def self.find_by_folder_name(record, user_id)
    self.where("lower(name) = ? AND user_id = ?", record.downcase, user_id)
  end


  #######################################################
  # Test to see if the input folder name already exists #
  #######################################################
  def self.find_by_name(record, user_id)
    self.where("lower(name) = ? AND user_id = ?", record.downcase, user_id)
  end

end
