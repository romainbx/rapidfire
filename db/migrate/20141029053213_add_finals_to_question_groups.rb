class AddFinalsToQuestionGroups < ActiveRecord::Migration
  def change
    add_column :rapidfire_question_groups, :final_text, :text
    add_column :rapidfire_question_groups, :final_link, :string
  end
end
