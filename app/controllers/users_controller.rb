class UsersController < ApplicationController
  def new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      @user.save
      login(@user)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def show
    if current_user.nil? || current_user.id != params[:id].to_i
      redirect_to new_user_url
    else
      @user = User.find(params[:id])
      render :show
    end

  end

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
