class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.string :title
      t.string :content
      t.string :files

      t.timestamps
    end
  end
end
