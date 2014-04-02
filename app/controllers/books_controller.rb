class BooksController < ApplicationController
  before_action :clear_database, :only => [:index]

  include BooksHelper

  # GET /books
  # GET /books.json
  def index
    flash[:notice] = find_books.to_s
  end

  def preview
    @isbn = find_isbn
    if flash[:notice] == @isbn.to_s 
      redirect_to "preview_path"
    else 
      @isbn
    end
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)
    @book.save
  end

  private
    def clear_database
      Book.destroy_all
    end

    def book_params
      params.require(:book).permit(:title, :author, :isbn, :release_date, :excerpt)
    end
end
