require 'test_helper'

class StrategicSponsorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @strategic_sponsor = strategic_sponsors(:one)
  end

  test "should get index" do
    get strategic_sponsors_url
    assert_response :success
  end

  test "should get new" do
    get new_strategic_sponsor_url
    assert_response :success
  end

  test "should create strategic_sponsor" do
    assert_difference('StrategicSponsor.count') do
      post strategic_sponsors_url, params: { strategic_sponsor: { description: @strategic_sponsor.description, name: @strategic_sponsor.name, position: @strategic_sponsor.position, short_name: @strategic_sponsor.short_name } }
    end

    assert_redirected_to strategic_sponsor_url(StrategicSponsor.last)
  end

  test "should show strategic_sponsor" do
    get strategic_sponsor_url(@strategic_sponsor)
    assert_response :success
  end

  test "should get edit" do
    get edit_strategic_sponsor_url(@strategic_sponsor)
    assert_response :success
  end

  test "should update strategic_sponsor" do
    patch strategic_sponsor_url(@strategic_sponsor), params: { strategic_sponsor: { description: @strategic_sponsor.description, name: @strategic_sponsor.name, position: @strategic_sponsor.position, short_name: @strategic_sponsor.short_name } }
    assert_redirected_to strategic_sponsor_url(@strategic_sponsor)
  end

  test "should destroy strategic_sponsor" do
    assert_difference('StrategicSponsor.count', -1) do
      delete strategic_sponsor_url(@strategic_sponsor)
    end

    assert_redirected_to strategic_sponsors_url
  end
end
