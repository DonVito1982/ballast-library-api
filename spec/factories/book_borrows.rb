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
FactoryBot.define do
  factory :book_borrow do
    due_at { "2026-01-09 11:26:28" }
    book_id { nil }
    user_id { nil }
  end
end
