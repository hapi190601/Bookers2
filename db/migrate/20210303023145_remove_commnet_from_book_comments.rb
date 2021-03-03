class RemoveCommnetFromBookComments < ActiveRecord::Migration[5.2]
  def change
    remove_column :book_comments, :commnet, :text
    remove_column :book_comments, :commnets, :text
  end
end
