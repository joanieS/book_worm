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
    @book = Book.find(params[:isbn])
    @book.ups = @book.ups+1
    @book.save
    # @genre = @book.genre
    flash[:notice] = "Liked!"
  end

  def dislike
    @book = Book.find(params[:isbn])
    @book.downs = @book.downs+1
    @book.save
  end
end
