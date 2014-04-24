class User < ActiveRecord::Base
  authenticates_with_sorcery!

  validates :password, confirmation: true
  validates_presence_of :password_confirmation
  
  validates :email, uniqueness: true

  def liked_books
    user_books = UserBook.where(user: self, liked: true)
    books = user_books.collect {|user_book| Book.find(user_book.book_id)}
  end

  def disliked_books
    user_books = UserBook.where(user: self, liked: false)
    books = user_books.collect {|user_book| Book.find(user_book.book_id)}
  end
end
