class Document < ActiveRecord::Base
  
  validates_uniqueness_of :identifier
  validates_format_of :identifier, :with => /^(\w|_)+$/,
      :message => 'should be like a Java identifier'
  
end
