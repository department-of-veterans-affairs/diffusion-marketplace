require 'test_helper'

class ClinicalConditionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @clinical_condition = clinical_conditions(:one)
  end

  test "should get index" do
    get clinical_conditions_url
    assert_response :success
  end

  test "should get new" do
    get new_clinical_condition_url
    assert_response :success
  end

  test "should create clinical_condition" do
    assert_difference('ClinicalCondition.count') do
      post clinical_conditions_url, params: { clinical_condition: { description: @clinical_condition.description, name: @clinical_condition.name, position: @clinical_condition.position, short_name: @clinical_condition.short_name } }
    end

    assert_redirected_to clinical_condition_url(ClinicalCondition.last)
  end

  test "should show clinical_condition" do
    get clinical_condition_url(@clinical_condition)
    assert_response :success
  end

  test "should get edit" do
    get edit_clinical_condition_url(@clinical_condition)
    assert_response :success
  end

  test "should update clinical_condition" do
    patch clinical_condition_url(@clinical_condition), params: { clinical_condition: { description: @clinical_condition.description, name: @clinical_condition.name, position: @clinical_condition.position, short_name: @clinical_condition.short_name } }
    assert_redirected_to clinical_condition_url(@clinical_condition)
  end

  test "should destroy clinical_condition" do
    assert_difference('ClinicalCondition.count', -1) do
      delete clinical_condition_url(@clinical_condition)
    end

    assert_redirected_to clinical_conditions_url
  end
end
