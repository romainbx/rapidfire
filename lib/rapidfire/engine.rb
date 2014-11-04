require 'active_model_serializers'
require 'simple_enum'
#require 'wicked_pdf'
require 'paperclip'
require 'writeexcel'
require 'axlsx'

module Rapidfire
  class Engine < ::Rails::Engine
    isolate_namespace Rapidfire
  end
end
