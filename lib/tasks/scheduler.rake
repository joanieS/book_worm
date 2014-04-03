desc "This task scrapes Goodreads and saves books"
task save_from_goodreads: :environment do
  Book.save_books
end
