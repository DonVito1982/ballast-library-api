require 'rails_helper'

RSpec.describe "Books", type: :request do
  describe "GET /index" do
    let(:url) { books_path }
    let(:member) { create(:user) }
    let(:headers) { authenticated_header(member) }
    let(:parsed_body) { ActiveSupport::JSON.decode(response.body) }

    it "returns a proper array" do
      create(:book)
      get(url, headers: headers)

      expect(parsed_body).to be_a(Array)
      expect(parsed_body.first.deep_symbolize_keys).to include(:id)
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
        # expect(response.body).to eq(9)
        expect(parsed_body).to include(:id)
      end
    end
  end
end
