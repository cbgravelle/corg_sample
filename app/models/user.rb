# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean          default(FALSE)
#

class User < ActiveRecord::Base
	attr_accessor	:password
	attr_accessible :name, :email, :password, :password_confirmation

	has_many(:microposts, :dependent => :destroy)

	email_regex =  /\A[\w+\-.]+@+[a-z\d\-.]+\.[a-z]+\z/i

	validates :name,  		:presence 		=> true,
							:length			=> {:maximum => 50}
	validates :email, 		:presence 		=> true,
							:format			=> {:with => email_regex},
							:uniqueness		=> { :case_sensitive => false}
	validates :password, 	:presence 		=> true,
							# Rails automatically creates a 'password_confirmation' attr with:
							:confirmation 	=> true,  	
							:length 		=> {:within => 6..40}

	before_save :encrypt_password

	def has_password?(submitted_password)
		encrypted_password == encrypt(submitted_password)
	end

	class << self
		def authenticate(email, submitted_password)
			#inside a class method, "User." is unnecessary:
			user = User.find_by_email(email)
			(user && user.has_password?(submitted_password)) ? user : nil
		end

		def authenticate_with_salt(id, cookie_salt)
			user = User.find_by_id(id)
			(user && user.salt = cookie_salt) ? user : nil
		end
	end

	private 	#'private' methods are not accessable outside of model 

		def encrypt_password
			self.salt = make_salt if self.new_record?
			self.encrypted_password = encrypt(self.password)
		end

		def encrypt(string)
			secure_hash("#{salt}--#{string}")
		end

		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end

		def make_salt
			secure_hash("#{Time.now.utc}--#{password}")
		end
end
