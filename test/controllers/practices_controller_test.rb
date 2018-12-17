require 'test_helper'

class PracticesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @practice = practices(:one)
  end

  test "should get index" do
    get practices_url
    assert_response :success
  end

  test "should get new" do
    get new_practice_url
    assert_response :success
  end

  test "should create practice" do
    assert_difference('Practice.count') do
      post practices_url, params: { practice: { additional_notes: @practice.additional_notes, business_case_summary: @practice.business_case_summary, description: @practice.description, is_program_office: @practice.is_program_office, is_vha_field: @practice.is_vha_field, medical_center: @practice.medical_center, name: @practice.name, position: @practice.position, short_name: @practice.short_name, support_network_email: @practice.support_network_email, va_pulse_link: @practice.va_pulse_link, vha_visn: @practice.vha_visn } }
    end

    assert_redirected_to practice_url(Practice.last)
  end

  test "should show practice" do
    get practice_url(@practice)
    assert_response :success
  end

  test "should get edit" do
    get edit_practice_url(@practice)
    assert_response :success
  end

  test "should update practice" do
    patch practice_url(@practice), params: { practice: { additional_notes: @practice.additional_notes, business_case_summary: @practice.business_case_summary, description: @practice.description, is_program_office: @practice.is_program_office, is_vha_field: @practice.is_vha_field, medical_center: @practice.medical_center, name: @practice.name, position: @practice.position, short_name: @practice.short_name, support_network_email: @practice.support_network_email, va_pulse_link: @practice.va_pulse_link, vha_visn: @practice.vha_visn } }
    assert_redirected_to practice_url(@practice)
  end

  test "should destroy practice" do
    assert_difference('Practice.count', -1) do
      delete practice_url(@practice)
    end

    assert_redirected_to practices_url
  end
end
