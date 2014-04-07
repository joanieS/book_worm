class AddUpsAndDownsToBook < ActiveRecord::Migration
  def change
    add_column :books, :ups, :integer
    add_column :books, :downs, :integer
  end
end
