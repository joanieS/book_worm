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

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.save
  end

  def like
    @book = Book.find(params[:isbn])
    @book.ups = @book.ups+1
    @book.save
    @genre = @book.genre
  end

  def dislike
    @book = Book.find(params[:isbn])
    @book.downs = @book.downs+1
    @book.save
  end

  private
    def book_params
      params.require(:book).permit(:title, :author, :isbn, :release_date, :excerpt)
    end
end
