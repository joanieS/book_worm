class AddLikedtoUserBooks < ActiveRecord::Migration
  def change
    add_column :user_books, :liked, :boolean
  end
end
