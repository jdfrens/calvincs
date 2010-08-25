require 'spec_helper'

describe "newsitems/_form.html.erb" do
  it "should render a form" do
    newsitem = mock_model(Newsitem, :headline => "", :teaser => "", :content => "",
                          :goes_live_at => Time.now, :expires_at => Time.now).as_new_record
    assign(:newsitem, newsitem)
    
    render
    
    rendered.should have_selector("form", :action => "/newsitems") do |form|
      form.should have_selector("tr:nth-child(1)") do |tr|
        tr.should have_selector("td", :content => "Headline")
        tr.should have_selector("td input[type=text]")
      end
      form.should have_selector("tr:nth-child(2)") do |tr|
        tr.should have_selector("td", :content => "Teaser")
        tr.should have_selector("td input[type=text]")
      end
      form.should have_selector("tr:nth-child(3)") do |tr|
        tr.should have_selector("td", :content => "Content")
        tr.should have_selector("td textarea")
      end
      form.should have_selector("#newsitem_goes_live_at_1i")
      form.should have_selector("#newsitem_expires_at_1i")
      form.should have_selector("input[type=submit]")
    end
  end
end
