class CreateBookBorrows < ActiveRecord::Migration[8.1]
  def change
    create_table :book_borrows do |t|
      t.timestamp :due_at, null: false
      t.timestamp :returned_at
      t.references :book, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
