class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :isbn
      t.string :release_date
      t.string :excerpt

      t.timestamps
    end
  end
end
