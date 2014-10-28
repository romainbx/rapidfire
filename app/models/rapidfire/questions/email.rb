module Rapidfire
  module Questions
    class Email < Rapidfire::Question
      def validate_answer(answer)
        super(answer)
        if rules[:presence] == "1" || answer.answer_text.present?
          answer.errors.add(:answer_text, :invalid) unless answer.answer_text =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
        end
      end
    end
  end
end