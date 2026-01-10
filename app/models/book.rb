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
class Book < ApplicationRecord
  has_many :book_borrows

  def self.filtered_by(filter_params)
    result = all
    if filter_params[:author].present?
      result = result.where(
        "author LIKE ?",
        "%" + Book.sanitize_sql_like(filter_params[:author]) + "%"
      )
    end
    if filter_params[:genre].present?
      result = result.where(
        "genre LIKE ?",
        "%" + Book.sanitize_sql_like(filter_params[:genre]) + "%"
      )
    end
    if filter_params[:title].present?
      result = result.where(
        "title LIKE ?",
        "%" + Book.sanitize_sql_like(filter_params[:title]) + "%"
      )
    end

    result
  end
end
