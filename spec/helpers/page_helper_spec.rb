require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PagesHelper do

  describe "displaying the title of a page" do
    it "should use the actual title of a normal page" do
      page = mock_model(Page, :subpage? => false, :title => "the lovely title")
      
      helper.page_title(page).should == "the lovely title"
    end

    it "should have a special title for a subpage" do
      page = mock_model(Page, :subpage? => true, :title => "you can't see me!!!", :identifier => "_the_subpage")

      helper.page_title(page).should == "SUBPAGE identified as _the_subpage"
    end
  end
end
