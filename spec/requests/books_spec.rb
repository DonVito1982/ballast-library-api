require 'rails_helper'

RSpec.describe "Books", type: :request do
  describe "GET /index" do
    let(:url) { books_path }
    let(:member) { create(:user) }
    let(:headers) { authenticated_header(member) }
    let(:parsed_body) { ActiveSupport::JSON.decode(response.body) }

    it "returns a proper array" do
      get(url, headers: headers)
      expect(parsed_body).to be_a(Array)
    end
  end

  describe "PUT /books/:id" do
    let(:book) { create(:book) }
    let(:url) { book_path(book) }
    let(:member) { create(:user) }
    let(:librarian) { create(:user, :librarian) }
    let(:params) do
      { book: { genre: "New genre" } }
    end

    before { put url, headers: headers, params: params }

    context "Logged member" do
      let(:headers) { authenticated_header(member) }

      it_behaves_like "an unauthorized request"
    end
  end
end
