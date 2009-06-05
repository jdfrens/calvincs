require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/newsitems/list.html.erb" do

  it "should have title" do
    template.should_receive(:render).with(:partial => 'newsitems')
    assigns[:year] = 1666

    render "newsitems/list"
    response.should have_tag("h1", "News of 1666")
  end

  it "should have listing rendered as partial" do
    template.should_receive(:render).with(:partial => 'newsitems').and_return("the listing")

    render "newsitems/list"
    response.should have_tag("#news-listing", "the listing")
  end

  it "should have restricted content" do
    template.should_receive(:render).with(:partial => 'newsitems')
    template.should_receive(:restrict_to).with(:edit)

    render "newsitems/list"
  end

end

