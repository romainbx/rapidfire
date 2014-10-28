module Rapidfire
  module ApplicationHelper
    def render_answer_form_helper(answer, form, disabled = false)
      partial = answer.question.type.to_s.split("::").last.downcase
      render partial: "rapidfire/answers/#{partial}.html.erb", locals: { f: form, answer: answer , :disabled => disabled}
    end

    def checkbox_checked?(answer, option)
      answer.answer_text.to_s.split(",").include?(option)
    end

    def conditional_question(question, response = [])
      response << question
      if question.question_condition
        return conditional_question(question.question_condition, response)
      else
        return response
      end
    end

    def conditional_question_ids(question, response = "")
      if question.question_condition
        response << " " + question.question_condition.id.to_s
        return conditional_question_ids(question.question_condition, response)
      else
        return response
      end
    end
  end

end
