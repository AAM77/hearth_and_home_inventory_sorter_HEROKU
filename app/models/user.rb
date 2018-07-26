class User < ActiveRecord::Base
  has_many :items
  has_many :folders
  has_many :categories

  validates_presence_of :username, :email, :password
  has_secure_password

  def initial_folders
    self.folders << Folder.create(name: "Home")
    self.folders << Folder.create(name: "Work")
  end

  def initial_categories
    self.categories << Category.create(name: "Books")
    self.categories << Category.create(name: "Clothes")
    self.categories << Category.create(name: "Electronics")
    self.categories << Category.create(name: "Furniture")
    self.categories << Category.create(name: "Health and Fitness")
    self.categories << Category.create(name: "Kitchenware")
    self.categories << Category.create(name: "Office Supplies")
    self.categories << Category.create(name: "Personal Grooming")
    self.categories << Category.create(name: "Shoes")
    self.categories << Category.create(name: "Video Games")
  end

  ####################################################
  # Test to see if the input username already exists #
  ####################################################
  def create_folder(folder_name)
    folder = self.folders.where("lower(name) = ?", folder_name.downcase)

    if folder.empty?
      self.folders << Folder.create(name: folder_name)
    end
  end



  ###########################################################
  # Convert the Username to a slug that can be searched for #
  ###########################################################
  def slug
    self.username.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    self.all.find {|s| s.slug == slug}
  end


  #################################################
  # Test to see if the input email already exists #
  #################################################

  def self.find_by_email(record)
    self.where('lower(email) = ?', record.downcase).first
  end


  ####################################################
  # Test to see if the input username already exists #
  ####################################################

  def self.find_by_username(record)
    self.where('lower(username) = ?', record.downcase).first
  end


end
