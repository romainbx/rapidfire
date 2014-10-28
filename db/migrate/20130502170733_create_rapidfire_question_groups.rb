class CreateRapidfireQuestionGroups < ActiveRecord::Migration
  def change
    create_table :rapidfire_question_groups do |t|
      t.string  :name
      t.timestamps
    end
    add_column :rapidfire_question_groups, :user_id, :integer
    add_column :rapidfire_question_groups, :type_cd, :integer, :default => 0, :null => false
  end
end
