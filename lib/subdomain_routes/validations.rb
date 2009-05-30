module SubdomainRoutes
  def self.valid_subdomain?(subdomain)
    subdomain =~ /^([a-z]|[a-z][a-z0-9]|[a-z]([a-z0-9]|\-[a-z0-9])*)$/
    # # TODO: could we use URI::parse instead?:
    # begin
    #   URI.parse "http://#{subdomain}.example.com"
    #   true
    # rescue URI::InvalidURIError
    #   false
    # end
  end
  
  module Validations
    module ClassMethods
      def validates_subdomain_format_of(*attr_names)
        configuration = { :on => :save }
        configuration.update(attr_names.extract_options!)
      
        validates_each(attr_names, configuration) do |record, attr_name, value|
          unless SubdomainRoutes.valid_subdomain?(value)
            record.errors.add(attr_name, :not_a_valid_subdomain, :default => configuration[:message], :value => value) 
          end
        end
      end
    end
  end
end

if defined? ActiveRecord::Base
  ActiveRecord::Base.send :extend, SubdomainRoutes::Validations::ClassMethods
end