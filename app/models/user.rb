class User < ActiveRecord::Base
  # id:integer (primary key)
  # email:string
  # password_digest:string (has_secure_password)
  # created_at:datetime
  # updated_at:datetime
  
  attr_accessible :email, :password, :password_confirmation
  has_secure_password
  
  validates :email, :presence => { :on => :create }, :email => :true
  validates :password, :presence => { :on => :create }
  validates :password_confirmation, :presence => { :on => :create }
end # model User
