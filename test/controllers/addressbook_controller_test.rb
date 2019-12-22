require 'test_helper'

class AddressbookControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get addressbook_index_url
    assert_response :success
  end

end
