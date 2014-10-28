module Rapidfire
  class Answer < ActiveRecord::Base
    belongs_to :question
    belongs_to :answer_group, inverse_of: :answers

    validates :question, :answer_group, presence: true
    validate :verify_answer_text, :if => "question.present?"

    # has_attached_file :document
    # do_not_validate_attachment_file_type :document

    has_many :documents, :dependent => :destroy
    accepts_nested_attributes_for :documents, :allow_destroy => true

    if Rails::VERSION::MAJOR == 3
      attr_accessible :question_id, :answer_group, :answer_text, :documents, :documents_attributes
    end

    def right?
      if self.question.right_answers
        if self.question.type == "Rapidfire::Questions::Checkbox"
          self.question.right_answers.split("\r\n").sort == self.answer_text.split(',').sort
        else
          self.question.right_answers.split("\r\n").include? self.answer_text
        end
      else
        true
      end
    end

    private
    def verify_answer_text
      question.validate_answer(self)
    end
  end
end
