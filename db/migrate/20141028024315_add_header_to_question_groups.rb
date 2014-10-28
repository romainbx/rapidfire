class AddHeaderToQuestionGroups < ActiveRecord::Migration
  def change
    add_column :rapidfire_question_groups, :header, :text
  end
end
