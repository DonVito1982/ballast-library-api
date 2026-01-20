# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'csv'

book_text = File.read(Rails.root.join('lib', 'seeds', 'books.csv'))
csv_books = CSV.parse(book_text, headers: true, encoding: 'UTF-8')

puts "Starting book seed"
previous_count = Book.count

csv_books.each do |row|
  next if Book.find_by(isbn: row["ISBN"])

  Book.create(
    isbn: row['ISBN'],
    title: row["Title"],
    author: row["Author"],
    genre: row["Genre"],
    total_copies: rand(3) + 1
  )
end

puts "#{Book.count - previous_count} books created"

user_test = File.read(Rails.root.join('lib', 'seeds', 'users.csv'))
csv_users = CSV.parse(user_test, headers: true, encoding: 'UTF-8')

puts "Starting User seed"

previous_count = User.count

csv_users.each do |row|
  next if User.find_by(username: row["Username"])

  User.create(
    username: row['Username'],
    first_name: row["FirstName"],
    last_name: row["LastName"],
    password: row["Password"],
    role: row["Role"]
  )
end

puts "#{User.count - previous_count} users created"

borrow_params = [
  { username: "user2", "book": 2, due_in: -9 },
  { username: "user3", "book": 3, due_in: -7 },
  { username: "user4", "book": 4, due_in: -5 },
  { username: "user5", "book": 5, due_in: -11 },
  { username: "user6", "book": 6, due_in: -3 },
  { username: "user7", "book": 7, due_in: -1 },
  { username: "user8", "book": 8, due_in: 0 },
  { username: "user9", "book": 9, due_in: 2 },
  { username: "user10", "book": 12, due_in: 5 },
  { username: "donvito", "book": 13, due_in: 6 },
  { username: "mirnita", "book": 14, due_in: 8 }
]

borrow_params.each do |borrow|
  user = User.find_by(username: borrow[:username])
  book = Book.find_by(id: borrow[:book])
  book_borrow = BookBorrow.find_by(user: user, book: book)
  if book_borrow
    puts book_borrow.due_at
    book_borrow.update(due_at: Time.now + borrow[:due_in].days)
    book_borrow.save
    puts book_borrow.due_at
    puts "Updated book borrow for #{borrow[:username]}"
  else
    book_borrow = book.book_borrows.create(user: user)
    book_borrow.update(due_at: Time.now + borrow[:due_in].days)
    puts "Created book borrow for #{borrow[:username]}"
  end
end
