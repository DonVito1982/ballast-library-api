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
require 'rails_helper'

RSpec.describe BookBorrow, type: :model do
  let(:member) { create(:user) }
  let(:other_member) { create(:user) }
  let(:book) { create(:book) }

  it "creates with due date" do
    new_book = member.book_borrows.create(book:)

    expect(BookBorrow.due_day(Time.now + 14.days).pluck(:id)).to include(new_book.id)
  end

  it "creates without returned date" do
    new_book = member.book_borrows.create(book:)

    expect(new_book.returned_at).to be_nil
  end

  it "forbids multiple borrows of the same book" do
    book.update(total_copies: 1)
    member.book_borrows.create(book:)
    another_borrow = BookBorrow.new(user: other_member, book: book)

    expect(another_borrow.valid?).to be_falsey
  end

  it "forbids multiple borrows from the same member" do
    book.update(total_copies: 2)
    member.book_borrows.create(book:)
    another_borrow = BookBorrow.new(user: member, book: book)

    expect(another_borrow.valid?).to be_falsey
  end
end
