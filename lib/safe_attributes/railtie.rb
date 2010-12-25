require 'safe_attributes'
require 'rails'

module SafeAttributes
  class Railtie < ::Rails::Railtie
    initializer "safeattributes.active_record" do |app|
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send :include, SafeAttributes
      end
    end
  end
end
