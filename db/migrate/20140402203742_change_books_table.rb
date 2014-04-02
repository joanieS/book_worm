class ChangeBooksTable < ActiveRecord::Migration
  def change
    change_column :books, :title, :text
    change_column :books, :author, :text
    change_column :books, :isbn, :text
    change_column :books, :release_date, :text
  end
end
