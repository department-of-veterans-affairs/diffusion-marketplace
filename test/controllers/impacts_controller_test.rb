require 'test_helper'

class ImpactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @impact = impacts(:one)
  end

  test "should get index" do
    get impacts_url
    assert_response :success
  end

  test "should get new" do
    get new_impact_url
    assert_response :success
  end

  test "should create impact" do
    assert_difference('Impact.count') do
      post impacts_url, params: { impact: { description: @impact.description, impact_category: @impact.impact_category, name: @impact.name, position: @impact.position, short_name: @impact.short_name } }
    end

    assert_redirected_to impact_url(Impact.last)
  end

  test "should show impact" do
    get impact_url(@impact)
    assert_response :success
  end

  test "should get edit" do
    get edit_impact_url(@impact)
    assert_response :success
  end

  test "should update impact" do
    patch impact_url(@impact), params: { impact: { description: @impact.description, impact_category: @impact.impact_category, name: @impact.name, position: @impact.position, short_name: @impact.short_name } }
    assert_redirected_to impact_url(@impact)
  end

  test "should destroy impact" do
    assert_difference('Impact.count', -1) do
      delete impact_url(@impact)
    end

    assert_redirected_to impacts_url
  end
end
