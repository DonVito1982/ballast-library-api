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
  scope :due_day, lambda { |day| where(due_at: day.beginning_of_day..day.end_of_day) }

  private

  def set_due_at
    self.due_at = Time.now + 14.days
  end
end
