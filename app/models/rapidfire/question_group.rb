module Rapidfire
  class QuestionGroup < ActiveRecord::Base
    belongs_to :user
    has_many  :questions, :dependent => :destroy
    has_many  :fieldsets, :dependent => :destroy
    validates :name, :presence => true

    before_destroy :destroy_answer_groups

    as_enum :type, :examen => 1, :formulaire => 0

    if Rails::VERSION::MAJOR == 3
      attr_accessible :name, :type_cd, :type, :header
    end

    def elements
      (questions + fieldsets).sort_by do |e|
        e.position || (questions + fieldsets).count
      end
    end

    def destroy_answer_groups
      AnswerGroup.where(:question_group_id => self.id).destroy_all
    end
  end
end
