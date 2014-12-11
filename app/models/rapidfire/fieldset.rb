module Rapidfire
  class Fieldset < ActiveRecord::Base
    belongs_to :question_group, :inverse_of => :fieldsets

    if Rails::VERSION::MAJOR == 3
      attr_accessible :question_group, :title, :title_cn, :description, :position, :private
    end
  end
end