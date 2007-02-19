require File.dirname(__FILE__) + '/../test_helper'

class PageTest < Test::Unit::TestCase
  fixtures :pages

  should "complain when duplicate identifier" do
    page = Page.new(
      :identifier => 'mission_statement', :content => 'something'
    )
    assert !page.valid?
  end

  should "allow underlines in identifier" do
    page = Page.new(
        :identifier => '_underlines_are_okay_', :title => 'Good',
        :content => 'something'
    )
    assert page.valid?
  end
      
  should "complain about invalid identifiers" do
    page = Page.new(
        :identifier => '  whitespacey  ', :title => 'Good',
        :content => 'something'
    )
    assert !page.valid?
    assert_equal 'should be like a Java identifier',
        page.errors[:identifier]
    
    page = Page.new(
        :identifier => 'punc-tu-ation', :title => 'Good',
        :content => 'something'
    )
    assert !page.valid?
  end
  
  should "complain about missing title" do
    page = Page.new(
        :identifier => 'okay', :title => '', :content => 'something'
    )
    assert !page.valid?
    assert_equal "can't be blank", page.errors[:title]
  end
  
  should "complain about missing content" do
    page = Page.new(
        :identifier => 'okay', :title => 'Valid Title', :content => ''
    )
    assert !page.valid?
    assert_equal "can't be blank", page.errors[:content]
  end
  
  should "render textile using RedCloth" do
    assert_equal "<p>We state <strong>our</strong> mission.</p>",
        Page.find(1).render_content
    assert_equal "<p>a b c d e f g <em>h i j k</em></p>",
        Page.find(2).render_content
    assert_equal "<p>home page text written in <strong>textile</strong></p>",
        Page.find(3).render_content
  end
  
end
