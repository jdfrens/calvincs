require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/courses/new.html.erb" do

  it "should render a form" do
    render "/courses/new"

    assert_select "form[action=/courses/save][method=post]" do
      assert_select "table" do
        assert_select "tr" do
          assert_select "td input#course_department[type=text]"
        end
        assert_select "tr" do
          assert_select "td input#course_number[type=text]"
        end
        assert_select "tr" do
          assert_select "td input#course_title[type=text]"
        end
        assert_select "tr" do
          assert_select "td input#course_credits[type=text]"
        end
        assert_select "tr" do
          assert_select "td textarea#course_description"
        end
        assert_select "tr" do
          assert_select "td input[type=submit]"
        end
      end
    end
  end
end
