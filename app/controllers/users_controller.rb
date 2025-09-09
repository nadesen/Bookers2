class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :ensure_current_user, only: [:edit, :update]

  def index
    @users = User.all
    @user = current_user
    @book = Book.new
  end

  def show
    # @user = User.find(params[:id]) ← set_userでセット済
    @books = @user.books
    @book = Book.new
    @user = current_user
  end

  def edit
    # @user = User.find(params[:id]) ← set_userでセット済
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_current_user
    redirect_to user_path(current_user) unless @user == current_user
  end

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end
end