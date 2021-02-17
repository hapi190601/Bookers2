class BooksController < ApplicationController

  def new
    @book = Book.new
  end

  def create
    @book = Book.new
    @book.user_id = current_user.id
    @book.save
    redirect_to book_path(@book.id)
  end

  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])

  end

  def destroy
    @book = Book.find[params[:id]]
    @book.user_id = current_user.id
    @book.destroy
    redeoiect_to books_path
  end

  # ストロングパラメータ
  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

end
