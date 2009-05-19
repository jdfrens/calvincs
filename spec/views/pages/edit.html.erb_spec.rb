require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/page/edit.html.erb" do

#  it "should handle a wide image" do
#    page = mock_model(Page, :subpage? => false, :title => "Mission Statement", :content => "We state our mission.")
#    assigns[:page] = page
#
#    render "/page/view"
#
#    assert_select "div#content" do
#      assert_select "h1", "Mission Statement"
#      assert_select "div#page_content", /We state our mission./
#      assert_select "div.img-right-wide" do
#        assert_select "img#cool-pic"
#        assert_select "p.img-caption", images(:mission_wide).caption
#      end
#      assert_select "h1 #page_title_1_in_place_editor", false
#      assert_select "p #page_content_1_in_place_editor", false
#      assert_select "p.identifier #page_identifier_1_in_place_editor", false
#    end
#  end

#  it "should handle narrow image" do
#    get :view, :id => 'mission_narrow'
#
#    assert_response :success
#    assert_select "div#content" do
#      assert_select "div.img-right-narrow" do
#        assert_select "img#cool-pic"
#        assert_select "p.img-caption", images(:mission_narrow).caption
#      end
#    end
#  end
#
#  it "should handle no image" do
#    get :view, :id => 'alphabet'
#
#    assert_response :success
#    assigns[:title].should == pages(:alphabet).title
#    assigns[:last_updated].should == pages(:alphabet).updated_at
#    assert_select "div#content div.img-right", false
#  end

end
