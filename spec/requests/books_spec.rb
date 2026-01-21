require 'rails_helper'

RSpec.describe "Books", type: :request do
  describe "GET /index" do
    let(:url) { books_path }
    let(:member) { create(:user) }
    let(:headers) { authenticated_header(member) }
    let(:parsed_body) { ActiveSupport::JSON.decode(response.body) }

    before do
      create(:book, genre: "SciFi", author: "George Lucas", title: "Star Wars")
      create(:book, genre: "SciFi", author: "Hayao Miyasaki", title: "Alita")
      create(:book, genre: "Humor", author: "George Harris")
      create(:book, genre: "Comic", author: "Stan Lee", title: "Civil War")
      get(url, headers:, params:)
    end

    context "it filters books on author name" do
      let(:params) { { author: "george" } }

      it "Filters on author name" do
        authors = parsed_body.map { |book| book["author"] }

        expect(authors).to include("George Lucas")
        expect(authors).not_to include("Stan Lee")
      end
    end

    context "it filters books on genre" do
      let(:params) { { genre: "comic" } }

      it "Filters on genre" do
        authors = parsed_body.map { |book| book["author"] }

        expect(authors).not_to include("George Lucas")
        expect(authors).to include("Stan Lee")
      end
    end

    context "it filters books on title" do
      let(:params) { { title: "alit" } }

      it "Filters on title" do
        authors = parsed_body.map { |book| book["author"] }

        expect(authors).not_to include("George Lucas")
        expect(authors).to include("Hayao Miyasaki")
      end
    end
  end

  describe "POST /books" do
    let(:url) { books_path }
    let(:member) { create(:user) }
    let(:librarian) { create(:user, :librarian) }
    let(:parsed_body) { ActiveSupport::JSON.decode(response.body) }

    before { post url, headers: headers, params: params }

    context "Logged member" do
      let(:headers) { authenticated_header(member) }
      let(:params) { attributes_for(:book) }

      it_behaves_like "an unauthorized request"
    end

    context "Logged lilbrarian" do
      let(:headers) { authenticated_header(librarian) }

      context "Incomplete params" do
        let(:params) do
          { book: { genre: "New genre" } }
        end

        it_behaves_like "a bad request"
      end

      context "Complete params" do
        let(:params) { { book: attributes_for(:book) } }

        it "creates a book" do
          expect(response).to have_http_status(:created)
          expect(parsed_body.symbolize_keys).to include(:id)
          expect(parsed_body.symbolize_keys).to include(:title)
        end
      end
    end
  end

  describe "PUT /books/:id" do
    let(:book) { create(:book) }
    let(:url) { book_path(book) }
    let(:member) { create(:user) }
    let(:librarian) { create(:user, :librarian) }
    let(:parsed_body) { ActiveSupport::JSON.decode(response.body).symbolize_keys }
    let(:params) do
      { book: { genre: "New genre" } }
    end

    before { put url, headers: headers, params: params }

    context "Logged member" do
      let(:headers) { authenticated_header(member) }

      it_behaves_like "an unauthorized request"
    end

    context "Logged librarian" do
      let(:headers) { authenticated_header(librarian) }

      it "updates the book" do
        book.reload

        expect(book.genre).to eq("New genre")
        expect(parsed_body).to include(:id)
      end
    end
  end

  describe "DELETE /books/:id" do
    let(:book) { create(:book) }
    let(:url) { book_path(book) }
    let(:member) { create(:user) }
    let(:librarian) { create(:user, :librarian) }

    before { delete url, headers: headers }

    context "Logged member" do
      let(:headers) { authenticated_header(member) }

      it_behaves_like "an unauthorized request"

      it "does not delete the book" do
        expect(Book.exists?(book.id)).to be true
      end
    end

    context "Logged librarian" do
      let(:headers) { authenticated_header(librarian) }

      it "deletes the book" do
        expect(response).to have_http_status(:no_content)
        expect(Book.exists?(book.id)).to be false
      end
    end

    context "Book with associated borrows" do
      it "returns unprocessable entity and does not delete the book" do
        borrow_user = create(:user)
        book_with_borrows = create(:book, total_copies: 1)
        book_borrow = create(:book_borrow, book: book_with_borrows, user: borrow_user)
        
        expect(book_borrow).to be_persisted
        expect(book_with_borrows.book_borrows.count).to eq(1)
        
        delete book_path(book_with_borrows), headers: authenticated_header(librarian)
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(Book.exists?(book_with_borrows.id)).to be true
      end
    end

    context "Non-existent book" do
      let(:url) { book_path(id: 99999) }
      let(:headers) { authenticated_header(librarian) }

      it "returns not found" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
