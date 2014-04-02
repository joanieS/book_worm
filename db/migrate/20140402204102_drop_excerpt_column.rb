class DropExcerptColumn < ActiveRecord::Migration
  def change
    remove_column :books, :excerpt 
  end
end
