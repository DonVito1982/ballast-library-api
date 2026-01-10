require 'rails_helper'

RSpec.describe "/book_borrows", type: :request do
  let(:member) { create(:user) }
  let(:librarian) { create(:user, :librarian) }
  let(:book) { create(:book) }
  let(:other_book) { create(:book) }


  describe "GET book_borrows/index" do
    let(:other_member) { create(:user) }
    let(:url) { book_borrows_path }
    let(:parsed_body) { ActiveSupport::JSON.decode(response.body) }

    before do
      create(:book_borrow, user: member, book: book, returned_at: Date.today)
      create(:book_borrow, user: other_member, book: other_book)
      get url, headers: headers, params: params
    end

    context "When no authenticated user" do
      let(:headers) { {} }
      let(:params) { {} }

      it_behaves_like "an unauthorized request"
    end

    context "When a member is logged in" do
      let(:headers) { authenticated_header(member) }
      let(:params) { {} }

      it "responds with ok" do
        expect(response).to be_successful
        expect(parsed_body).to be_a(Array)
      end

      it "responds without borrows from other users" do
        other_member.reload

        parsed_body.each do |borrow|
          expect(borrow["id"]).not_to eq(other_member.id)
        end
      end
    end

    context "When a librarian is logged in" do
      let(:headers) { authenticated_header(librarian) }
      let(:params) { { returned: "false" } }

      it "responds with ok" do
        expect(response).to be_successful
        expect(parsed_body).to be_a(Array)
      end

      it "responds without borrows from other users" do
        other_member.reload
        member.reload

        response_user_ids = parsed_body.map { |item| item["id"] }

        expect(response_user_ids).not_to include(member.id)
        expect(response_user_ids).to include(other_member.id)
      end
    end
  end

  describe "GET /show" do
    let(:url) { book_borrow_path(book_borrow) }
    let(:headers) { authenticated_header(logged_user) }
    let(:book_borrow) { create(:book_borrow, book:, user: member) }

    before { get url, headers: headers }

    context "when the lendee is logged in" do
      let(:logged_user) { member }

      it "renders a successful response" do
        expect(response).to be_successful
      end
    end

    context "when the lendee is not logged in" do
      let(:other_member) { create(:user) }
      let(:logged_user) { other_member }

      it_behaves_like "an unauthorized request"
    end

    context "when a librarian is logged in" do
      let(:logged_user) { librarian }

      it "renders a successful response" do
        expect(response).to be_successful
      end
    end
  end

  describe "POST /create" do
    let(:url) { book_borrows_path }
    let(:headers) { authenticated_header(member) }

    before { post url, headers:, params: }

    context "with valid parameters" do
      let(:params) { { book_borrow: { book_id: book.id } } }

      it "creates a new BookBorrow" do
        expect(response).to have_http_status(:created)
      end
    end
  end

  describe "PATCH /update" do
    let(:url) { book_borrow_path(book_borrow) }
    let(:book_borrow) { create(:book_borrow, user: member, book:) }
    let(:params) { { book_borrow: { returned: "true" } } }

    before { patch url, headers:, params: }

    context "with logged in member" do
      let(:headers) { authenticated_header(member) }

      it_behaves_like "an unauthorized request"
    end

    context "with logged in librarian" do
      let(:headers) { authenticated_header(librarian) }

      it "updates the BookBorrow" do
        expect(response).to have_http_status(:ok)
        book_borrow.reload
        expect(book_borrow.returned?).to be_truthy
      end
    end
  end

  describe "DELETE /destroy" do
    let(:url) { book_borrow_path(book_borrow) }
    let(:book_borrow) { create(:book_borrow, user: member, book:) }

    before { delete url, headers: }

    context "with logged in member" do
      let(:headers) { authenticated_header(member) }

      it_behaves_like "an unauthorized request"
    end

    context "with logged in librarian" do
      let(:headers) { authenticated_header(librarian) }

      it "updates the BookBorrow" do
        expect(response).to have_http_status(:no_content)
        expect(BookBorrow.find_by(id: book_borrow.id)).to be_nil
      end
    end
  end
end
