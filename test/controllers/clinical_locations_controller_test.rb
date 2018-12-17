require 'test_helper'

class ClinicalLocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @clinical_location = clinical_locations(:one)
  end

  test "should get index" do
    get clinical_locations_url
    assert_response :success
  end

  test "should get new" do
    get new_clinical_location_url
    assert_response :success
  end

  test "should create clinical_location" do
    assert_difference('ClinicalLocation.count') do
      post clinical_locations_url, params: { clinical_location: { description: @clinical_location.description, name: @clinical_location.name, position: @clinical_location.position, short_name: @clinical_location.short_name } }
    end

    assert_redirected_to clinical_location_url(ClinicalLocation.last)
  end

  test "should show clinical_location" do
    get clinical_location_url(@clinical_location)
    assert_response :success
  end

  test "should get edit" do
    get edit_clinical_location_url(@clinical_location)
    assert_response :success
  end

  test "should update clinical_location" do
    patch clinical_location_url(@clinical_location), params: { clinical_location: { description: @clinical_location.description, name: @clinical_location.name, position: @clinical_location.position, short_name: @clinical_location.short_name } }
    assert_redirected_to clinical_location_url(@clinical_location)
  end

  test "should destroy clinical_location" do
    assert_difference('ClinicalLocation.count', -1) do
      delete clinical_location_url(@clinical_location)
    end

    assert_redirected_to clinical_locations_url
  end
end
