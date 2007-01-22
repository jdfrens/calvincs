require File.dirname(__FILE__) + '/../test_helper'

class DocumentTest < Test::Unit::TestCase
  fixtures :documents

  should "complain when duplicate identifier" do
    document = Document.new(
      :identifier => 'mission_statement', :content => ''
    )
    assert !document.valid?
  end

  should "allow underlines in identifier" do
    document = Document.new(
        :identifier => '_underlines_are_okay_', :title => 'Good'
    )
    assert document.valid?
  end
      
  should "complain about invalid identifiers" do
    document = Document.new(
        :identifier => '  whitespacey  ', :title => 'Good'
    )
    assert !document.valid?
    assert_equal 'should be like a Java identifier',
        document.errors[:identifier]
    
    document = Document.new(
        :identifier => 'punc-tu-ation', :title => 'Good'
    )
    assert !document.valid?
  end
  
  should "complain about missing title" do
    document = Document.new(
        :identifier => 'okay', :title => ''
    )
    assert !document.valid?
    assert_equal "can't be blank", document.errors[:title]
  end
  
end
