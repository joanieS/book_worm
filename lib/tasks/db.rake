namespace :db do
  desc "TODO"
  task save_from_goodreads: :environment do
    Book.save_books
  end

end
