module Rapidfire
  class FieldsetsController < Rapidfire::ApplicationController
    respond_to :html, :js

    before_filter :find_question_group!
    before_filter :find_fieldset!, :only => [:edit, :update, :destroy]

    def new
      @fieldset = Rapidfire::Fieldset.new(:question_group => @question_group)
      @fieldset.position = @question_group.elements.count
      respond_with(@fieldset)
    end

    def create
      #form_params = params[:fieldset].merge(:question_group => @question_group)
      @fieldset = Rapidfire::Fieldset.new(ad_params.merge(:question_group => @question_group))
      @fieldset.save

      respond_with(@fieldset, location: index_location)
    end

    def edit
      respond_with(@fieldset)
    end

    def update
      #form_params = params[:fieldset].merge(:fieldset => @fieldset)
      @fieldset.update_attributes(ad_params)

      respond_with(@fieldset, location: index_location)
    end

    def destroy
      @fieldset.destroy

      respond_with(@fieldset, location: index_location)
    end

    private
    def ad_params
      params.require(:fieldset).permit(:question_group, :title, :title_cn, :description, :position, :private)
    end

    def find_question_group!
      @question_group = QuestionGroup.find(params[:question_group_id])
    end

    def find_fieldset!
      @fieldset = @question_group.fieldsets.find(params[:id])
    end

    def index_location
      rapidfire.question_group_questions_url(@question_group)
    end
  end
end