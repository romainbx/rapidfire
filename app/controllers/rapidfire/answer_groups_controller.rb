module Rapidfire
  class AnswerGroupsController < Rapidfire::ApplicationController
    before_filter :find_question_group!

    def show
      @answer_group_builder = AnswerGroupBuilder.new(answer_group_params)
      @answer_group = AnswerGroup.find(params[:id])

      respond_to do |format|
        format.html
        format.pdf do
          render :pdf => "file_name", 
            :footer => { :right => '[page] of [topage]' },
            :show_as_html => false
        end
      end
    end

    def new
      @answer_group_builder = AnswerGroupBuilder.new(answer_group_params)

      respond_to do |format|
        format.html
        format.pdf do
          render :pdf => "file_name", 
            :footer => { :right => '[page] of [topage]' },
            :show_as_html => false
        end
      end
    end

    def create
      @answer_group_builder = AnswerGroupBuilder.new(answer_group_params)
      if @answer_group_builder.save
        if !@answer_group_builder.question_group.final_text.blank?
          redirect_to final_question_group_path(@answer_group_builder.question_group)
        elsif !@answer_group_builder.question_group.final_link.blank?
          redirect_to @answer_group_builder.question_group.final_link
        else
          redirect_to question_groups_path
        end
      else
        render :new
      end
    end

    def edit
      @answer_group_builder = AnswerGroupBuilder.new(answer_group_params)
      @answer_group = AnswerGroup.find(params[:id])
    end

    def update
      @answer_group = AnswerGroup.find(params[:id])

      params[:answer_group].each do |question_id, answer_attributes|
        if answer = @answer_group.answers.find { |a| a.question_id.to_s == question_id.to_s }
          text = answer_attributes[:answer_text]
          answer.answer_text = text.is_a?(Array) ? strip_checkbox_answers(text).join(',') : text
          #answer.answer_text = text.is_a?(Array) ? text.join(',') : text

          if answer.question.type == "Rapidfire::Questions::File"
            answer.documents_attributes = answer_attributes[:documents_attributes]
          end
        else
          answer = Answer.new(:question_id => question_id)

          text = answer_attributes[:answer_text]
          answer.answer_text = text.is_a?(Array) ? strip_checkbox_answers(text).join(',') : text
          #answer.answer_text = text.is_a?(Array) ? text.join(',') : text

          if answer.question.type == "Rapidfire::Questions::File"
            answer.documents_attributes = answer_attributes[:documents_attributes]
          end

          @answer_group.answers << answer
        end
      end
      if @answer_group.save
        if !@answer_group.question_group.final_text.blank?
          redirect_to final_question_group_path(@answer_group.question_group)
        elsif !@answer_group.question_group.final_link.blank?
          redirect_to @answer_group.question_group.final_link
        else
          redirect_to question_groups_path, :notice  => "Successfully updated."
        end
      else
        render :action => 'edit'
      end
      # if @answer_group.update_attributes(params[:answer_group])
      #   redirect_to question_groups_path, :notice  => "Successfully updated."
      # else
      #   render :action => 'edit'
      # end
    end

    private

    def strip_checkbox_answers(text)
      text.reject(&:blank?).reject { |t| t == "0" }
    end
    
    def find_question_group!
      @question_group = QuestionGroup.find(params[:question_group_id])
    end

    def answer_group_params
      answer_params = { params: params[:answer_group] }
      answer_params.merge(user: current_user, question_group: @question_group)
    end
  end
end
