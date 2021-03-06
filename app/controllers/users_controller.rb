class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy]
  before_action :get_current_user, only: [:show, :edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account!"
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
    old_password = params[:user][:old_password]
    if @user.authenticate(old_password)
      if @user.update_attributes(user_params)
        flash[:success] = "Account successfully updated!"
        redirect_to user_path
      else
        rename_password_error_messages
        render 'edit'
      end
    elsif old_password.blank?
      @user.update_attribute(:email, params[:user][:email])
      flash[:success] = "Email successfully updated!"
      redirect_to user_path
    else
      @user.errors.add(:old_password, "doesn't match the existing password")
      render 'edit'
    end
  end

  def destroy
    log_out
    @user.destroy
    flash[:success] = "Account successfully deleted."
    redirect_to root_path
  end

  private

    def get_current_user
      @user = current_user
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

    # Replace occurances of "Password" with "New password"
    def rename_password_error_messages
      if @user.errors.messages[:password_confirmation] == ["doesn't match Password"]
        @user.errors.messages[:password_confirmation] = ["doesn't match New password"]
      end

      password_errors = @user.errors.messages[:password]
      if password_errors
        @user.errors.messages[:new_password] = password_errors
        @user.errors.delete(:password)
      end
    end
end
