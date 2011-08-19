# Copyright (C) 2011 AMEE UK Ltd. - http://www.amee.com
# Released as Open Source Software under the BSD 3-Clause license. See LICENSE.txt for details.

module ActsAsChained
  
  module ActsAsHelpers
    
    def acts_as_chained target, options={}
      # Add functionality into class
      include ActsAsChained::InstanceMethods
      extend ActsAsChained::ClassMethods
      # Set exclusions
      self.chain_exclusions = [:id] + (options[:except] || [])
      self.chain_target = target
    end
    
  end
   
  module ClassMethods
    
    def chain_exclusions=(exclusions)
      @@ChainExclusions = exclusions 
    end
    
    def chain_exclusions
      @@ChainExclusions
    end

    def chain_target=(target)
      @@Target = target 
    end

    def chain_target
      @@Target
    end

    def define_attribute_methods
      # First - default behaviour
      super
      # Then, for each non-excluded attribute
      (columns_hash.keys.map{|x| x.to_sym} - self.chain_exclusions).each do |attribute| 
        
        # Redefine accessor method
        define_method("#{attribute}_with_chain") do
          chain_impl(attribute, attribute)
        end
        alias_method_chain attribute, :chain

        # Define before type cast accessor methods
        #define_method("#{attribute}_before_type_cast_with_chain") do
        #  chain_impl(attribute, "#{attribute}_before_type_cast")
        #end
        #alias_method_chain "#{attribute}_before_type_cast", :chain

      end 
    end
  end
    
  module InstanceMethods
  
    def chain_impl(attribute, method_name, options = {})
      logger.info "calling #{method_name}from #{category} #{options[:argument]}"
      if options[:argument]
        val = send "#{method_name}_without_chain", options[:argument]
      else
        val = send "#{method_name}_without_chain"
      end
      logger.info "--#{category}: #{val.to_yaml}"
      if val.nil? && !self.class.chain_exclusions.include?(attribute) && send(self.class.chain_target)
        logger.info "--#{category}: chaining!"
        if options[:argument]
          val = send(self.class.chain_target).send(method_name, options[:argument])
        else
          val = send(self.class.chain_target).send(method_name)
        end
        logger.info "--#{category}: #{val.to_yaml}"
      end
      logger.info "--#{category}: done"
      val
    end

    # Chain general read_attribute in case people use it
    def read_attribute_with_chain(attribute)
      chain_impl(attribute, :read_attribute, :argument => attribute)
    end
    
    # Chain read_attribute_before_type_cast method
    def read_attribute_before_type_cast_with_chain(attribute)
      chain_impl(attribute, :read_attribute_before_type_cast, :argument => attribute)
    end

    def self.included(base)
      base.alias_method_chain :read_attribute, :chain
      base.alias_method_chain :read_attribute_before_type_cast, :chain
    end
    
  end
   
end