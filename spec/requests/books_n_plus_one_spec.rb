require 'rails_helper'

RSpec.describe 'Books N+1', type: :request do
  describe 'GET /index query count' do
    it 'does not trigger N+1 when listing books' do
      member = create(:user)
      headers = authenticated_header(member)

      # Create multiple books and some borrows to simulate realistic load
      books = create_list(:book, 5)
      # create a user to associate borrows with
      borrower = create(:user)

      books.each_with_index do |book, i|
        # create some borrows, some returned, some not
        create(:book_borrow, book: book, user: borrower) if i.odd?
        create(:book_borrow, book: book, user: borrower, returned_at: Time.now) if i.even?
      end

      queries = []

      callback = lambda do |_name, _start, _finish, _id, payload|
        sql = payload[:sql]
        # ignore schema queries and transaction control statements
        next if sql =~ /sqlite_master|schema_migrations|BEGIN|COMMIT|ROLLBACK|SAVEPOINT|RELEASE|PRAGMA/i

        queries << sql
      end

      ActiveSupport::Notifications.subscribed(callback, 'sql.active_record') do
        get books_path, headers: headers
      end

      # Filter only relevant queries (books and book_borrows). Ignore auth/session SQL performed before controller action.
      relevant_queries = queries.select { |sql| sql =~ /\bbooks\b|\bbook_borrows\b/i }

      # Expect no more than 2 relevant queries: one for books, one for loading book_borrows via includes
      expect(relevant_queries.size).to be <= 2, "Expected at most 2 SQL queries related to books but got:\n#{relevant_queries.join("\n----\n")}"
    end
  end
end
