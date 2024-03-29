# Copyright (C) 2011 AMEE UK Ltd. - http://www.amee.com
# Released as Open Source Software under the BSD 3-Clause license. See LICENSE.txt for details.

require 'acts_as_chained'

# Add extensions into ActiveRecord::Base
ActiveRecord::Base.class_eval { extend ActsAsChained::ActsAsHelpers }