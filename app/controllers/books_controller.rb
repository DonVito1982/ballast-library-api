class BooksController < ApplicationController
  before_action :set_book, except: [:index]

  def index
    @books = Book.all
    render json: @books
  end

  def show
  end

  def update
    raise Error::Unauthorized unless current_user.librarian?

    @book.update(book_params)
    render json: @book
  end

  private
  def book_params
    params.require(:book).permit(%i[genre title author isbn])
  end

  def set_book
    @book = Book.find(params[:id])
  end
end
