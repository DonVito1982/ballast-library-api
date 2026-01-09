class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :author, null: false
      t.string :title, null: false
      t.string :isbn, null: false
      t.string :genre, null: false
      t.integer :total, null: false, default: 0

      t.timestamps
    end
  end
end
