# == Schema Information
#
# Table name: book_borrows
#
#  id          :integer          not null, primary key
#  due_at      :datetime         not null
#  returned_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  book_id     :integer          not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_book_borrows_on_book_id  (book_id)
#  index_book_borrows_on_user_id  (user_id)
#
# Foreign Keys
#
#  book_id  (book_id => books.id)
#  user_id  (user_id => users.id)
#
class BookBorrow < ApplicationRecord
  belongs_to :book
  belongs_to :user

  before_create :set_due_at

  scope :returned, -> { where.not(returned_at: nil) }
  scope :due, -> { where(returned_at: nil) }
  scope :due_day, lambda { |day| where(due_at: day.beginning_of_day..day.end_of_day).where(returned_at: nil) }

  validate :available_book, :no_repeated_borrower

  def returned?
    returned_at.present?
  end

  def self.filtered_by(filter_params)
    if filter_params["returned"] == "false"
      due
    else
      all
    end
  end

  def available_book
    extra_available = 0
    extra_available = 1 if persisted?
    unless book.book_borrows.due.count < (book.total_copies + extra_available)
      errors.add(:book, "Book not available")
    end
  end

  def no_repeated_borrower
    available_borrows = 0
    available_borrows = 1 if persisted?
    unless BookBorrow.where(user: user, book: book).count <= available_borrows
      errors.add(:user, "Repeated borrower")
    end
  end

  private

  def set_due_at
    self.due_at = Time.now + 14.days
  end
end
