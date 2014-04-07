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
    flash[:notice] = "Liked!"
  end

end
