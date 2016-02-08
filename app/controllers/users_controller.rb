class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    #debugger     #uncomment to use byebug
  end

  def new
    @user = User.new
  end
 
  def create
    @user = User.create(user_params) #fixed
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation) 
    end
end
