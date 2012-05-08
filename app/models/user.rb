class User < ActiveRecord::Base
  # id:integer (primary key)
  # name:string
  # email:string
  # password_digest:string (has_secure_password)
  # created_at:datetime
  # updated_at:datetime
  
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password
  
  validates :name, :presence => true
  validates :email, :presence => { :on => :create }, :email => :true
  validates :password, :presence => { :on => :create }
  validates :password_confirmation, :presence => { :on => :create }
end # model User
