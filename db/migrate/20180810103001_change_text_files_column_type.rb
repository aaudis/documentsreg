class ChangeTextFilesColumnType < ActiveRecord::Migration[5.2]
  def change
    change_column :documents, :content, :text
    change_column :documents, :files, :text
  end
end
