module Rapidfire
  class Document < ActiveRecord::Base
    belongs_to :answer

    has_attached_file :asset
    do_not_validate_attachment_file_type :asset
  end
end