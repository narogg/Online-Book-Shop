class User < ActiveRecord::Base

  attr_accessor :password
  validates_presence_of :password, :email
  validates_confirmation_of :password
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  before_save :encrypt_password
  
  def encrypt_password
	self.password_salt = BCrypt::Engine.generate_salt
	self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
  end 
  
  def self.authenticate(email, password)
    user = User.where(email: email).first
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
     user
    else
     nil
    end
  end
   
end
