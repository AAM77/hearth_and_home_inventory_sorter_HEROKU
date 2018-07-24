class User < ActiveRecord::Base
  has_many :items
  has_many :folders

  validates_presence_of :username, :email, :password
  has_secure_password

  def initial_folders
    self.folders << Folder.create(name: "Home")
    self.folders << Folder.create(name: "Work")
  end

  ####################################################
  # Test to see if the input username already exists #
  ####################################################
  def create_folder(folder_name)
    folder = self.folders.where("lower(name) = ?", folder_name.downcase)

    if !folder.empty?
      yield
    else
      self.folders << Folder.create(name: folder_name)
    end
  end

  def create_item(item_name)
    self.items << Item.create(name: item_name)
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
