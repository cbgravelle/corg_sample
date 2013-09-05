class UsersController < ApplicationController
  

  def show
  	@user = User.find(params[:id])
  	@title = @user.name
  end

  def new
  	@user = User.new
  	@title = "Sign Up"
  end

  def create
  	# raise params[:user].inspect # used for debugging form params
  	@user = User.new(params[:user])

  	if @user.save
      flash[:success] = "Welcome to Corg-Sample App!"
  		redirect_to user_path(@user)
  	else
  		@title = "Sign Up"
  		render 'new'
  	end
  end

end
