# == Schema Information
#
# Table name: books
#
#  id           :integer          not null, primary key
#  author       :string           not null
#  genre        :string           not null
#  isbn         :string           not null
#  title        :string           not null
#  total_copies :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class BookSerializer < ActiveModel::Serializer
  attributes :id, :author, :genre, :isbn, :title, :total_copies, :available_copies

  def available_copies
    object.total_copies - object.book_borrows.due.count
  end
end
