module ApplicationHelper

	# Return a title on a per-page basis
	def corg_title
		base_title = "Corg-Sample"
		if @title.nil?
			base_title
		else
			"#{base_title} | #{@title}"
		end
	end

	def logo_img
		image_tag("logo.png", :alt=> "Corg_Sample", :class => "logo round")
	end

	def dotdot(input, chars)
		input.length < chars ? input.chomp : input[0...chars].chomp + "..."
	end

	def micropost_delete_link(input)
		user = input.user rescue User.find(input.user_id)
		if current_user?(user)
			link_to "delete", input, 
					:method => :delete, 
					:confirm => "You sure?",
					:title => "Delete '" + dotdot(input.content, 30).gsub(/\r\n/, ' ') + "'"
		end
	end

end
