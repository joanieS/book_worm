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
    add_to_liked
    # @book = Book.find_by(isbn: session[:isbn])
    # @book.ups += 1
    # @book.save
    # @genres = @book.genres
    flash[:notice] = "Liked!"
    render nothing: true
  end

  def liked_books
    @liked_books = session[:liked_books] 
  end

  def dislike
    @book = Book.find_by(isbn: session[:isbn])
    # @book.downs += 1
    # @book.save
    flash[:notice] = "Disliked!"
  end

  def saved_books
    @isbns = Book.liked_books
  end

end
