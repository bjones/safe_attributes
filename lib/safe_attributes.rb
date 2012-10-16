require 'active_support'
require 'safe_attributes/base'

module SafeAttributes
  extend ActiveSupport::Concern
  include SafeAttributes::Base
end

require 'safe_attributes/railtie.rb' if defined?(Rails)
