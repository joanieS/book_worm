class BooksController < ApplicationController

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
    Book.liked_books << session[:isbn]
    # @book = Book.find_by(isbn: session[:isbn])
    # @book.ups += 1
    # @book.save
    # @genres = @book.genres
    flash[:notice] = "Liked!"
  end

  def dislike
    @book = Book.find_by(isbn: session[:isbn])
    # @book.downs += 1
    # @book.save
    flash[:notice] = "Disliked!"
  end

  def saved_books
    @books = Book.liked_books
  end

end
