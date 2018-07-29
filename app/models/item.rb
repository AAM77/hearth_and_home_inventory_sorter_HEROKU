class Item < ActiveRecord::Base
  belongs_to :user
  has_many :item_folders
  has_many :item_categories
  has_many :folders, through: :item_folders
  has_many :categories, through: :item_categories

  validates_presence_of :name

  def slug
    self.name.gsub(" ", "-")
  end

  def self.find_by_item_slug(slug, item_id, user_id)
    self.all.find {|s| s.slug == slug && s.id == item_id && s.user_id == user_id}
  end

  #######################################################
  # Test to see if the input folder name already exists #
  #######################################################
  def self.find_by_item_name(record, user_id)
    self.where("lower(name) = ? AND id = ? AND user_id = ?", record.downcase, id, user_id)
  end

  def self.find_by_name(record, user_id)
    self.where("lower(name) = ? AND user_id = ?", record.downcase, user_id)
  end

end
