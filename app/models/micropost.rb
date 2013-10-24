# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Micropost < ActiveRecord::Base
	attr_accessible :content

	belongs_to :user

	validates :content, :presence => true, :length => { :maximum => 140 }
	validates :user_id, :presence => true

	default_scope { order('microposts.created_at DESC') }

	def self.from_users_followed_by(user)
		followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    	where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          		user_id: user.id)

		# followed_ids = user.following.map(&:id).join(", ")
		# where("user_id IN (#{followed_ids}) OR user_id = ?", user)

		# if followed_ids.blank?
		# 	 where("user_id = ?", user)
		# else where("user_id IN (#{followed_ids}) OR user_id = ?", user)
		# end


		# Micropost.where("user_id IN (#{followed_ids}) OR user_id = ?", user)
		# Micropost.where("user_id = ? OR user_id = ?", followed_ids, user)
		# followed_ids = %(SELECT followed_id FROM relationships 
        #             	 WHERE follower_id = :user_id)
		
	end

end
