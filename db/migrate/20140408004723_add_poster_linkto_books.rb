class AddPosterLinktoBooks < ActiveRecord::Migration
  def change
    add_column :books, :poster_link, :text
  end
end
