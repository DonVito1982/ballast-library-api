class BooksController < ApplicationController
  before_action :set_book, except: [ :index, :create ]

  def index
    @books = Book.filtered_by(filter_params).includes(:book_borrows)
    render json: @books
  end

  def show
    render json: @book
  end

  def create
    raise Error::Unauthorized unless current_user.librarian?

    book = Book.create!(book_params)
    render json: book, status: :created
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
    @book = Book.find_by!(id: params[:id])
  end

  def filter_params
    params.permit(%i[title author genre])
  end
end
