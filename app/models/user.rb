class User < ActiveRecord::Base
  has_many :items
  has_many :folders

  validates_presence_of :username, :email, :password
  has_secure_password

  #def initialize
    ## Have the user initialize with 3 pre-created folders!!
  #end

  def slug
    self.username.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    self.all.find {|s| s.slug == slug}
  end

end
