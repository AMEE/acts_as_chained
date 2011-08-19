== acts_as_chained

A gem to provide attribute chaining capabilities to models. This means
that if a field is not set in an object, it can be dynamically looked up
in another object.

Licensed under the BSD 3-Clause license (See LICENSE.txt for details)

Author: James Smith

Copyright: Copyright (c) 2011 AMEE UK Ltd

Homepage: http://github.com/AMEE/acts_as_chained

Documentation: http://rubydoc.info/gems/acts_as_chained/frames

== INSTALLATION

1) Install gem
    > sudo gem install acts_as_chained

2) Add to your environment.rb:
      config.gem 'acts_as_chained'

   Alternatively, add to Gemfile if using bunder:
      gem 'acts_as_chained'

== REQUIREMENTS

ActiveRecord >= 2.3 or above. Not tested with ActiveRecord 3 yet.

== USAGE

class MyModel < ActiveRecord::Base

  acts_as_chained :chain_lookup
  
  has_one :other_model
  
  def chain_lookup
    other_model
  end
  
end

In the above example, if (and only if) an attribute is nil in the current object,
the chain_lookup method is called to find the place that data should be chained from. 
If the method returns an object, the same attribute will be looked up in that object 
(which may chain it further along if it wants to). If it returns nil, the attribute 
value from the current object will be returned, which will of course be nil.

The chain does not affect writing, only reading, so that if a form sets an attribute to
a new value, that value will appear in subsequent reads of the attribute.

acts_as_chained will automatically chain all attributes except :id. To exclude other
attributes, add the :except parameter.

  acts_as_chained :lookup, :except => [:not_this_one, :or_this_one]