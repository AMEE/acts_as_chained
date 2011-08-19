# Copyright (C) 2011 AMEE UK Ltd. - http://www.amee.com
# Released as Open Source Software under the BSD 3-Clause license. See LICENSE.txt for details.

module ActsAsChained
  
  module ActsAsHelpers
    
    def acts_as_chained target, options={}
      # Add functionality into class
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
    
    def chain_target=(target)
      @@Target = target 
    end

    def define_attribute_methods
      # Define all attributes, first of all
      super
      # Now add our chained versions
      (columns_hash.keys.map{|x| x.to_sym} - @@ChainExclusions).each do |attribute| 
        define_method(attribute.to_s + '_with_chain') do
          logger.info "fetching " + attribute.to_s + ' from ' + category
          val = send(attribute.to_s + '_without_chain')
          logger.info "--#{category}: " + val.to_yaml
          if val.nil? && self.send(@@Target)
            logger.info "--#{category}: chaining!"
            val = self.send(@@Target).send(attribute)
            logger.info "--#{category}: " + val.to_yaml
          end
          logger.info "--#{category}: done"
          val
        end
        alias_method_chain attribute, :chain
      end
    end
    
  end
   
end