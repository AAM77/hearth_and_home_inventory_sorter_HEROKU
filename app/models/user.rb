class User < ActiveRecord::Base
  has_many :items
  has_many :folders

  validates_presence_of :username, :email, :password
  has_secure_password

  def initial_folders
    folder1 = Folder.new(name: "Home")
    folder2 = Folder.new(name: "Work")
    folder1.save
    folder2.save
    self.folders << folder1
    self.folders << folder2
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
  def self.all_emails
    emails = self.all.collect { |user| user.email.downcase }
  end

  def self.find_by_email(record)
    self.where('lower(email) = ?', record.downcase).first
  end


  ####################################################
  # Test to see if the input username already exists #
  ####################################################

  def self.find_by_username(record)
    self.where('lower(username) = ?', record.downcase).first
  end


  #######################################################
  # Test to see if the input folder name already exists #
  #######################################################
  def all_folders
    folders = self.folders.collect { |folder| folder.name.downcase }
  end

  def find_by_folder(record)
    all_folders.include?(record.downcase)
  end

  def self.find_by_folder(record)
    self.where({ name: record, user_id: current_user.id })
  end


end
