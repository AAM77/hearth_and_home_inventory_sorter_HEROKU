class Category < ActiveRecord::Base
  has_many :item_categories
  has_many :items, through: :item_categories

  def slug
    self.name.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    self.all.find {|s| s.slug == slug}
  end

  def self.all_categories
    categories = self.all.collect { |category| category.name.downcase }
  end

  def self.find_by_case(record)
    self.all_categories.include?(record.downcase)
  end

end
