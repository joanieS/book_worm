class RenamePosterLink < ActiveRecord::Migration
  def change
    rename_column :books, :poster_link, :cover_link
  end
end
