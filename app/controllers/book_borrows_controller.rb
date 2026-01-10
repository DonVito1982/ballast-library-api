class BookBorrowsController < ApplicationController
  before_action :set_book_borrow, only: %i[ show update destroy ]

  # GET /book_borrows
  def index
    if current_user.librarian?
      @book_borrows = BookBorrow.filtered_by(filter_params)
    else
      @book_borrows = current_user.book_borrows.filtered_by(filter_params)
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
    @book_borrow = current_user.book_borrows.create(create_book_borrow_params)

    if @book_borrow.save
      render json: @book_borrow, status: :created
    else
      render json: @book_borrow.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /book_borrows/1
  def update
    raise ActionController::BadRequest unless update_book_borrow_params

    raise Error::Unauthorized unless current_user.librarian?

    if @book_borrow.update(returned_at: Time.now)
      render json: @book_borrow
    else
      render json: @book_borrow.errors, status: :unprocessable_content
    end
  end

  # DELETE /book_borrows/1
  def destroy
    raise Error::Unauthorized unless current_user.librarian?

    @book_borrow.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_borrow
      @book_borrow = BookBorrow.find(params.expect(:id))
    end

    def update_book_borrow_params
      params.require(:book_borrow).permit(:returned)
    end

    def create_book_borrow_params
      params.require(:book_borrow).permit(:book_id)
    end

    def filter_params
      params.permit(:returned)
    end
end
