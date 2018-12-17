require 'test_helper'

class AncillaryServicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ancillary_service = ancillary_services(:one)
  end

  test "should get index" do
    get ancillary_services_url
    assert_response :success
  end

  test "should get new" do
    get new_ancillary_service_url
    assert_response :success
  end

  test "should create ancillary_service" do
    assert_difference('AncillaryService.count') do
      post ancillary_services_url, params: { ancillary_service: { description: @ancillary_service.description, name: @ancillary_service.name, position: @ancillary_service.position, short_name: @ancillary_service.short_name } }
    end

    assert_redirected_to ancillary_service_url(AncillaryService.last)
  end

  test "should show ancillary_service" do
    get ancillary_service_url(@ancillary_service)
    assert_response :success
  end

  test "should get edit" do
    get edit_ancillary_service_url(@ancillary_service)
    assert_response :success
  end

  test "should update ancillary_service" do
    patch ancillary_service_url(@ancillary_service), params: { ancillary_service: { description: @ancillary_service.description, name: @ancillary_service.name, position: @ancillary_service.position, short_name: @ancillary_service.short_name } }
    assert_redirected_to ancillary_service_url(@ancillary_service)
  end

  test "should destroy ancillary_service" do
    assert_difference('AncillaryService.count', -1) do
      delete ancillary_service_url(@ancillary_service)
    end

    assert_redirected_to ancillary_services_url
  end
end
