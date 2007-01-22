require File.dirname(__FILE__) + '/../test_helper'
require 'document_controller'

# Re-raise errors caught by the controller.
class DocumentController; def rescue_action(e) raise e end; end

class DocumentControllerTest < Test::Unit::TestCase
  def setup
    @controller = DocumentController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  should "get form to create a new document" do
    get :create
    assert_response :success
    assert_standard_layout
    assert_template "document/create"
    assert_select "h1", "Create Document"
    assert_document_form
  end
  
  #
  # Helpers
  #
  private
  
  def assert_document_form
    assert_select "td input#document_identifier"
    assert_select "td textarea#document_content"
    assert_select "td input[type=submit]"
  end
  
end
