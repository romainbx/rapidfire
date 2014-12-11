module Rapidfire
  class QuestionForm < Rapidfire::BaseService
    AVAILABLE_QUESTIONS =
      [
       Rapidfire::Questions::Checkbox,
       Rapidfire::Questions::Date,
       Rapidfire::Questions::Datetime,
       Rapidfire::Questions::Long,
       Rapidfire::Questions::Numeric,
       Rapidfire::Questions::Radio,
       Rapidfire::Questions::Select,
       Rapidfire::Questions::Short,
       Rapidfire::Questions::Email,
       Rapidfire::Questions::File
      ]

    QUESTION_TYPES = AVAILABLE_QUESTIONS.inject({}) do |result, question|
      question_name = question.to_s.split("::").last
      question_name = I18n.t("activerecord.models.rapidfire.questions."+question_name.downcase)
      result[question_name] = question.to_s
      result
    end

    attr_accessor :question_group, :question,
      :type, :question_text, :answer_options, :answer_presence,
      :answer_minimum_length, :answer_maximum_length,
      :answer_greater_than_or_equal_to, :answer_less_than_or_equal_to,
      :right_answers, :points, :position, :show_in_pdf, :question_text_cn, 
      :question_condition_id, :question_condition_answers, :col_size, :clear_cd, :clear, :private

    delegate :valid?, :errors, :id, :to => :question

    def to_model
      question
    end

    def initialize(params = {})
      from_question_to_attributes(params[:question]) if params[:question]
      super(params)
      @question ||= question_group.questions.new
    end

    def save
      @question.new_record? ? create_question : update_question
    end

    private
    def create_question
      klass = nil
      if QUESTION_TYPES.values.include?(type)
        klass = type.constantize
      else
        errors.add(:type, :invalid)
        return false
      end

      @question = klass.create(to_question_params)
    end

    def update_question
      @question.update_attributes(to_question_params)
    end

    def to_question_params
      {
        :type => type,
        :question_group => question_group,
        :question_text  => question_text,
        :question_text_cn  => question_text_cn,
        :answer_options => answer_options,
        :right_answers   => right_answers,
        :points => points,
        :private => private,
        :position => position,
        :show_in_pdf => show_in_pdf,
        :question_condition_id => question_condition_id,
        :question_condition_answers => question_condition_answers,
        :col_size => col_size,
        :clear_cd => clear_cd,
        :validation_rules => {
          :presence => answer_presence,
          :minimum  => answer_minimum_length,
          :maximum  => answer_maximum_length,
          :greater_than_or_equal_to => answer_greater_than_or_equal_to,
          :less_than_or_equal_to    => answer_less_than_or_equal_to
        }
      }
    end

    def from_question_to_attributes(question)
      self.type             = question.type
      self.question_group   = question.question_group
      self.question_text    = question.question_text
      self.question_text_cn = question.question_text_cn
      self.answer_options   = question.answer_options
      self.right_answers    = question.right_answers
      self.points           = question.points
      self.position         = question.position
      self.private         = question.private
      self.show_in_pdf      = question.show_in_pdf
      self.col_size         = question.col_size
      self.clear_cd         = question.clear_cd
      self.question_condition_id            = question.question_condition_id
      self.question_condition_answers       = question.question_condition_answers
      self.answer_presence                  = question.rules[:presence]
      self.answer_minimum_length            = question.rules[:minimum]
      self.answer_maximum_length            = question.rules[:maximum]
      self.answer_greater_than_or_equal_to  = question.rules[:greater_than_or_equal_to]
      self.answer_less_than_or_equal_to     = question.rules[:less_than_or_equal_to]
    end
  end
end
