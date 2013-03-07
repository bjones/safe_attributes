require 'active_support'

module SafeAttributes
  module Base
    extend ActiveSupport::Concern

    module ClassMethods
      # 
      # Within your model call this method once with a list of 
      # methods matching either attribute() or attribute=() for 
      # attributes (column names) you do not want to create the
      # the normal method for.  You should not need to do this
      # but the option is there in case the default list is 
      # inadequate.
      #
      def bad_attribute_names(*attrs)
        @bad_attribute_names ||= lambda {
          methods = Array.new(attrs.collect { |x| x.to_sym })
          methods += ActiveRecord::Base.public_instance_methods.collect { |x| x.to_sym }
          methods += ActiveRecord::Base.protected_instance_methods.collect { |x| x.to_sym }
          methods += ActiveRecord::Base.private_instance_methods.collect { |x| x.to_sym }
          methods -= [:id]
          return methods
        }.call
      end

      # 
      # Override the default implementation to not create the
      # attribute() method if that method name is in the list of
      # bad names
      #
      def define_method_attribute(attr_name)
        return if (bad_attribute_names.include?(attr_name.to_sym))
        super(attr_name)
      end

      #
      # Override the default implementation to not create the
      # attribute= method if that method name is in the list of
      # bad names
      #
      def define_method_attribute=(attr_name)
        method = attr_name + '='
        return if (bad_attribute_names.include?(method.to_sym))
        super(attr_name)
      end

      def instance_method_already_implemented?(method_name)
        begin 
          return super(method_name)
        rescue ActiveRecord::DangerousAttributeError
          return true
        end
        return false
      end
    end

    def read_attribute_for_validation(attr)
      if (self.attributes.include?(attr.to_s))
        self[attr.to_sym]
      else
        self.send(attr.to_s) if (self.respond_to?(attr.to_sym))
      end
    end

    def attribute_change(attr)
      [changed_attributes[attr], read_attribute_for_validation(attr)] if attribute_changed?(attr)
    end

  end
end
