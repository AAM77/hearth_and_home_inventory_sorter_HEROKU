require_relative './concerns/user_findables.rb'
require_relative './concerns/user_helpers.rb'

class User < ActiveRecord::Base
  extend UserFindables::ClassMethods
  extend UserHelpers::ClassMethods
  include UserHelpers::InstanceMethods

  has_many :items
  has_many :folders
  has_many :categories

  validates_presence_of :username, :email, :password
  has_secure_password

end
