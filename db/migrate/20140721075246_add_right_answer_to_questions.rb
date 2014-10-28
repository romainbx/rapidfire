class AddRightAnswerToQuestions < ActiveRecord::Migration
  def change
  	
  	add_column :rapidfire_questions, :right_answers, :text
  	add_column :rapidfire_questions, :points, :float, :default => 0
  	add_column :rapidfire_questions, :show_in_pdf, :boolean, :default => true
  	add_column :rapidfire_questions, :question_text_cn, :string
  	add_column :rapidfire_questions, :col_size, :integer, :default => 4, :null => false
  	add_column :rapidfire_questions, :clear_cd, :integer, :default => 0, :null => false
  	add_column :rapidfire_questions, :question_condition_id, :integer
  	add_column :rapidfire_questions, :question_condition_answers, :text
  end
end
