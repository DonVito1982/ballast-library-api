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
FactoryBot.define do
  factory :book do
    author { Faker::Book.author }
    title { Faker::Book.title }
    isbn { Faker::Barcode.isbn }
    genre { Faker::Book.genre }
    total_copies { rand(3) + 1 }
  end
end
