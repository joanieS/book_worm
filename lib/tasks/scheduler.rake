desc "This task scrapes Goodreads and saves books"
task :save_from_goodreads => :environment do
  Book.save_books
end

desc "Grabs book covers from Google Books"
task :grab_covers => :environment do
  Book.grab_covers
end

# task :save_from_goodreads_list, :url => :environment do |t, url|
#   Book.save_books_for(url)
# end
