class User < ActiveRecord::Base
  authenticates_with_sorcery!

  validates :email, uniqueness: true
  validates_presence_of :email

  validates_presence_of :password

  validates :password, confirmation: true
  validates_presence_of :password_confirmation

  def liked_books
    user_books = UserBook.where(user: self, liked: true)
    books = user_books.collect {|user_book| Book.find(user_book.book_id)}
  end

  def disliked_books
    user_books = UserBook.where(user: self, liked: false)
    books = user_books.collect {|user_book| Book.find(user_book.book_id)}
  end
end
