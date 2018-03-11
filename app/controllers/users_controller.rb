class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:info] = "Account was successfully created. Welcome!"
      log_in @user
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
