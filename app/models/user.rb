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

  def slug
    self.username.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    self.all.find {|s| s.slug == slug}
  end

  def self.all_usernames
    usernames = self.all.collect { |user| user.username.downcase }
  end

  def self.all_emails
    usernames = self.all.collect { |user| user.email.downcase }
  end

  def self.find_by_email(record)
    self.all_emails.include?(record.downcase)
  end

  def self.find_by_username(record)
    self.all_usernames.include?(record.downcase)
  end

end
