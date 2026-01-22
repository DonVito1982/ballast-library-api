class BooksController < ApplicationController
  before_action :set_book, except: [ :index, :create ]
  before_action :require_librarian, only: %i[create update destroy]

  def index
    @books = Book.filtered_by(filter_params).includes(:book_borrows)
    render json: @books
  end

  def show
    render json: @book
  end

  def create
    book = Book.create!(book_params)
    render json: book, status: :created
  end

  def update
    @book.update(book_params)
    render json: @book
  end

  def destroy
    @book.destroy!
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
