class BooksController < ApplicationController
  before_action :set_user, only: [:like, :dislike]
  before_action :set_book, only: [:like, :dislike]


  def index
  end

  def preview
    @isbn = Book.all.sample.isbn
    if session[:isbn] == @isbn
      redirect_to "preview_path"
    else
      session[:isbn] = @isbn
      @isbn
    end
  end

  def like
    UserBook.find_or_create_by(user: @user, book: @book, liked: true) unless @user == false
    render nothing: true
  end

  def liked_books
    @liked_books = session[:liked_books]
  end

  def dislike
    UserBook.find_or_create_by(user: @user, book: @book, liked: false) unless @user == false
    render nothing: true
  end

  def saved_books
    @isbns = Book.liked_books
  end

  private
    def set_user
      @user = current_user
    end

    def set_book
      @book = Book.find_by(isbn: session[:isbn])
    end

end
