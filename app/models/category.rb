class Category < ActiveRecord::Base
  belongs_to :user
  has_many :item_categories
  has_many :items, through: :item_categories

  validates_presence_of :name

  def slug
    self.name.gsub(" ", "-")
  end

  def self.find_by_category_slug(slug, user_id)
    self.all.find {|s| s.slug == slug && s.user_id == user_id}
  end

  #######################################################
  # Test to see if the input category name already exists #
  #######################################################
  def self.find_by_category_name(record, user_id)
    self.where("lower(name) = ? AND user_id = ?", record.downcase, user_id)
  end

  #######################################################
  # Test to see if the input folder name already exists #
  #######################################################
  def self.find_by_name(record, user_id)
    self.where("lower(name) = ? AND user_id = ?", record.downcase, user_id)
  end

end
