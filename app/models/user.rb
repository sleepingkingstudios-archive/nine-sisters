class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  has_secure_password
  
  validates_presence_of :email, :password, :password_confirmation, :on => :create
end # model User
