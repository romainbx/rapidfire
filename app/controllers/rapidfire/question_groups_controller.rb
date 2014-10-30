module Rapidfire
  class QuestionGroupsController < Rapidfire::ApplicationController
    before_filter :authenticate_administrator!, except: :index
    respond_to :html, :js
    respond_to :json, only: :results

    def index
      @question_groups = QuestionGroup.all
      respond_with(@question_groups)
    end

    def new
      @question_group = QuestionGroup.new
      respond_with(@question_group)
    end

    def create
      @question_group = QuestionGroup.new(question_group_params)
      @question_group.user = current_user
      
      if @question_group.save

      #respond_with(@question_group, location: rapidfire.question_groups_url)

        redirect_to question_group_questions_path(@question_group)
      else
        render :new
      end
    end

    def final
      @question_group = QuestionGroup.find(params[:id])
    end

    def edit
      @question_group = QuestionGroup.find(params[:id])
      respond_with(@question_group)
    end

    def update_positions
      @question_group = QuestionGroup.find(params[:id])

      if !params[:positions][:questions].nil?
        params[:positions][:questions].each do |element_id, position|
          Question.find(element_id).update_attributes(:position => position)
        end
      end

      if !params[:positions][:fieldsets].nil?
        params[:positions][:fieldsets].each do |element_id, position|
          Rapidfire::Fieldset.find(element_id).update_attributes(:position => position)
        end
      end
      redirect_to question_group_questions_path(@question_group), :notice  => "Positions mises à jour"
    end

    def duplicate
      model = QuestionGroup.find(params[:id])
      @question_group = model.dup
      @question_group.name = "Copie de #{@question_group.name}"
      model.questions.each do |question|
        @question_group.questions << question.dup
      end

      if @question_group.save
        redirect_to edit_question_group_path(@question_group)
      end
    end

    def update
      @question_group = QuestionGroup.find(params[:id])
      params.permit!
      if @question_group.update_attributes(params[:question_group])
        redirect_to question_groups_path, :notice  => "Successfully updated."
      else
        render :action => 'edit'
      end
    end

    def destroy
      @question_group = QuestionGroup.find(params[:id])
      @question_group.destroy

      respond_with(@question_group)
    end

    def results
      @question_group = QuestionGroup.find(params[:id])
      @answer_groups = Rapidfire::AnswerGroup.where(:question_group => params[:id])
      @question_group_results = QuestionGroupResults.new(question_group: @question_group).extract

      respond_to do |format|
        format.html { respond_with(@question_group_results, root: false) }
        format.xls do
          p = Axlsx::Package.new
          p.workbook.add_worksheet(:name => "Résultats") do |sheet|
            column_names = []
            @question_group.questions.each do |question|
              if @question_group.examen? && (question.points && question.points > 0)
                column_names << "#{question.question_text} [#{question.points.prettify} points]"
              else
                column_names << question.question_text
              end
            end
            if @question_group.examen?
              column_names << "Total"
            end
            sheet.add_row column_names

            @answer_groups.each do |answer_group|
              column_contents = []
              total = 0.0
              total_user = 0.0
              @question_group.questions.each do |question|
                answer = answer_group.answers.where(:question => question).first
                if answer
                  if answer.question.type == "Rapidfire::Questions::File"
                    column_contents << "#{request.protocol}#{request.host_with_port}#{answer.document.url}"

                  elsif @question_group.examen? && answer.question.points > 0
                    column_contents << answer.answer_text
                    if answer.right?
                      total_user += answer.question.points
                    end
                    total += answer.question.points
                  else
                    column_contents << answer.answer_text
                  end
                else
                  column_contents << ""
                end
              end
              if @question_group.examen?
                column_contents << total_user.prettify
              end
              sheet.add_row column_contents
            end
          end
          p.use_shared_strings = true
          p.serialize("posts.xlsx")
          send_data p.to_stream.read, :filename => "Résultats - #{@question_group.name}.xlsx"
        end
      end
    end

    private
    def question_group_params
      if Rails::VERSION::MAJOR == 4
        params.require(:question_group).permit(:name)
      else
        params[:question_group]
      end
    end
  end
end
