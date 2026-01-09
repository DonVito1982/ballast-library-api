# == Schema Information
#
# Table name: books
#
#  id         :integer          not null, primary key
#  author     :string           not null
#  genre      :string           not null
#  isbn       :string           not null
#  title      :string           not null
#  total      :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Book < ApplicationRecord
end
