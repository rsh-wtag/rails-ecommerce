class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin, only: %i[all_users index destroy]
  before_action :set_user, only: %i[show edit update destroy]

  def all_users
    @users = User.all
  end

  def show
    redirect_to edit_user_path if current_user != @user && !current_user.admin?
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'Profile updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_path, notice: 'User was successfully deleted.'
    else
      redirect_to users_path, alert: 'Error deleting user.'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :address, :phone)
  end

  def authorize_admin
    redirect_to root_path, alert: 'Access denied.' unless current_user&.admin?
  end
end
