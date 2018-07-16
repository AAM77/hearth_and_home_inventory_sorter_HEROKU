class Item < ActiveRecord::Base
  belongs_to :user
  has_many :item_folders
  has_many :item_categories
  has_many :folders, through: :item_folders
  has_many :categories, through: :item_categories

  def slug
    self.name.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    self.all.find {|s| s.slug == slug}
  end

  def self.all_items
    items = self.all.collect { |item| item.name.downcase }
  end

  def self.find_by_case(record)
    self.all_items.include?(record.downcase)
  end

end
