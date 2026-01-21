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
require 'rails_helper'

RSpec.describe Book, type: :model do
  describe "deletion with associated borrows" do
    let(:user) { create(:user) }

    context "when book has no borrows" do
      let(:book) { create(:book, total_copies: 1) }

      it "can be deleted successfully" do
        book_id = book.id
        book.destroy
        expect(Book.exists?(book_id)).to be false
      end

      it "destroy returns the book object" do
        result = book.destroy
        expect(result).to be_a(Book)
        expect(result.destroyed?).to be true
      end
    end

    context "when book has associated borrows" do
      let(:book) { create(:book, total_copies: 1) }

      before do
        create(:book_borrow, book: book, user: user)
      end

      it "cannot be deleted" do
        book_id = book.id
        book.destroy
        expect(Book.exists?(book_id)).to be true
      end

      it "returns false on destroy" do
        expect(book.destroy).to be false
      end

      it "adds error to the book" do
        book.destroy
        expect(book.errors[:base]).to be_present
      end

      it "raises ActiveRecord::RecordNotDestroyed on destroy!" do
        expect { book.destroy! }.to raise_error(ActiveRecord::RecordNotDestroyed)
      end
    end
  end
end
