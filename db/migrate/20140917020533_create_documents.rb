class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :rapidfire_documents do |t|
      t.string :name
      t.integer :answer_id

      t.timestamps
    end

    add_attachment :rapidfire_documents, :asset
  end
end
