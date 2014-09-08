require 'digest/sha1'
class User < ActiveRecord::Base
#source :http://stackoverflow.com/questions/2767811/agile-web-development-with-rails

  # attrs
  attr_accessor :password

  # class methods
  class << self
    def encrypt(password, salt)
      Digest::SHA1.hexdigest("--#{salt}--#{password}--");
    end
  end

  # validation
  #validates_presence_of       :name
  validates :name, :presence => true, :uniqueness => true
  validates_confirmation_of   :password

  # callbacks
  before_save :encrypt_password

  protected

  def encrypt_password
    return if password.blank?
    if new_record?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now}--#{name}--")
    end
    self.encrypted_password = User.encrypt(password, salt)
  end

end


#require 'digest/sha2'
#class User < ActiveRecord::Base
#  validates :name, :presence => true, :uniqueness => true
#  validates :password, :confirmation => true
#  attr_accessor :password_confirmation
#  attr_reader :password
#  validate :password_must_be_present
#  class << self
#  def authenticate(name, password)
#    if user = find_by_name(name)
#      if user.hashed_password == encrypt_password(password, user.salt)
#       user
#      end
#    end
#  end
#  
#  def encrypt_password(password, salt)
#	Digest::SHA2.hexdigest(password + "wibble" + salt)
#	end
#  end
#  
#  # 'password' is a virtual attribute
#  def password=(password)
#	@password = password
#	if password.present?
#	generate_salt
#	self.hashed_password = self.class.encrypt_password(password, salt)
#	end
#  end
#  
#  private
#  def password_must_be_present
#	errors.add(:password, "Missing password" ) unless hashed_password.present?
#	end
#	
#  def generate_salt
#	self.salt = self.object_id.to_s + rand.to_s
#  end
#  
#
#end





#require 'digest/sha2'
#
#class User < ActiveRecord::Base
#  validates :name, :presence => true, :uniqueness => true
#  validates :password, :confirmation => true
#  attr_accessor :password_confirmation
#  attr_reader :password
#  validate :password_must_be_present
#  
#class << self
#	def authenticate(name, password)
#	if user = find_by_name(name)
#	  if user.hashed_password == encrypt_password(password, user.salt)
#        user
#	  end
#	end
#end
#  
#  
#  
#  
#  private
#  def password_must_be_present
#    errors.add(:password, "Missing password" ) unless hashed_password.present?
#  end
#  
#  def encrypt_password(password, salt)
#    Digest::SHA2.hexdigest(password + "wibble" + salt)
#  end
#  
#  def generate_salt
#	self.salt = self.object_id.to_s + rand.to_s
#  end
  
#  
#  
#  def password=(password)
#	@password = password
#	if password.present?
#		generate_salt
#		self.hashed_password = self.class.encrypt_password(password, salt)
#	end
#  end
#
#end
