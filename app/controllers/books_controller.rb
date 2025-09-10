class BooksController < ApplicationController
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def correct_user
    @book = Book.find(params[:id])
    redirect_to books_path, alert: "Not authorized" unless @book.user == current_user
  end

  def index
    @books = Book.all
    @book = Book.new
    @user = current_user
    @users = User.all

  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book)
    else
      flash.now[:alert] = "Error creating book. Please check the form."
      @books = Book.all
      @user = current_user
      @users = User.all
      render 'index'
    end
  end

  def show
    @book = Book.find(params[:id])
    @book_new = Book.new
    @user = @book.user
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(@book)
    else
      flash.now[:alert] = "Error updating book. Please check the form."
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path, notice: "You have deleted book successfully."
  end

  private
  def book_params
    params.require(:book).permit(:title, :body)
  end
end
