class AddDocumentToAnswer < ActiveRecord::Migration
  def change
  	add_attachment :rapidfire_answers, :document
  end
end
