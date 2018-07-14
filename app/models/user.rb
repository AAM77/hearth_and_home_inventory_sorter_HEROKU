class User < ActiveRecord::Base
  has_many :items
  has_many :folders

  validates_presence_of :username, :email, :password
  has_secure_password
end
