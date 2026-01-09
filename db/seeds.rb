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
