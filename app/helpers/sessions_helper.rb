module SessionsHelper

	def sign_in(user)
		cookies.permanent.signed[:remember_token] = [user.id, user.salt]
		# this puts remember_token securely onto user's browser:
		# cookies[:remember_token] = { :value => user.id, :expires => 20.years.from_now.utc }
		current_user = user
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		@current_user ||= user_from_remember_token
		# ||= assigns @current_user to user_from_remember_token IF @current_user is nil
		# a = a || b   ===   a ||= b
	end

	def signed_in?
		!current_user.nil?
	end

	def sign_out
		cookies.delete(:remember_token)
		current_user = nil
	end

	def current_user?(user)
		user == current_user
	end

	def authenticate
		deny_access unless signed_in?
	end

	def deny_access
	  store_location
      redirect_to signin_path, :notice => "Please sign in to access this page."
    end

    def store_location
    	session[:return_to] = request.fullpath
    end

    def redirect_back_or(default)
    	redirect_to(session[:return_to] || default)
    	clear_return_to
    end

    def clear_return_to
    	session[:return_to] = nil
    end

	private

		def user_from_remember_token
			User.authenticate_with_salt(*remember_token)
			# * above unwraps one layer of sq brackets- *[[1,2]] = [1,2]
		end

		def remember_token
			cookies.signed[:remember_token] || [nil,nil]
		end

end
