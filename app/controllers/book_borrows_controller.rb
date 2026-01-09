class BookBorrowsController < ApplicationController
  before_action :set_book_borrow, only: %i[ show update destroy ]

  # GET /book_borrows
  def index
    if current_user.librarian?
      @book_borrows = BookBorrow.all
    else
      @book_borrows = current_user.book_borrows
    end

    render json: @book_borrows
  end

  # GET /book_borrows/1
  def show
    if current_user.member? && @book_borrow.user != current_user
      raise Error::Unauthorized
    end

    render json: @book_borrow
  end

  # POST /book_borrows
  def create
    @book_borrow = BookBorrow.new(book_borrow_params)

    if @book_borrow.save
      render json: @book_borrow, status: :created, location: @book_borrow
    else
      render json: @book_borrow.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /book_borrows/1
  def update
    if @book_borrow.update(book_borrow_params)
      render json: @book_borrow
    else
      render json: @book_borrow.errors, status: :unprocessable_content
    end
  end

  # DELETE /book_borrows/1
  def destroy
    @book_borrow.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_borrow
      @book_borrow = BookBorrow.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def book_borrow_params
      params.expect(book_borrow: [ :due_at, :book_id, :user_id ])
    end
end
