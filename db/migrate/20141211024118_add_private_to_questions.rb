class AddPrivateToQuestions < ActiveRecord::Migration
  def change
    add_column :rapidfire_fieldsets, :private, :boolean, :default => false, :null => false
    add_column :rapidfire_questions, :private, :boolean, :default => false, :null => false
  end
end
