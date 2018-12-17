require 'test_helper'

class VaSecretaryPrioritiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @va_secretary_priority = va_secretary_priorities(:one)
  end

  test "should get index" do
    get va_secretary_priorities_url
    assert_response :success
  end

  test "should get new" do
    get new_va_secretary_priority_url
    assert_response :success
  end

  test "should create va_secretary_priority" do
    assert_difference('VaSecretaryPriority.count') do
      post va_secretary_priorities_url, params: { va_secretary_priority: { description: @va_secretary_priority.description, name: @va_secretary_priority.name, position: @va_secretary_priority.position, short_name: @va_secretary_priority.short_name } }
    end

    assert_redirected_to va_secretary_priority_url(VaSecretaryPriority.last)
  end

  test "should show va_secretary_priority" do
    get va_secretary_priority_url(@va_secretary_priority)
    assert_response :success
  end

  test "should get edit" do
    get edit_va_secretary_priority_url(@va_secretary_priority)
    assert_response :success
  end

  test "should update va_secretary_priority" do
    patch va_secretary_priority_url(@va_secretary_priority), params: { va_secretary_priority: { description: @va_secretary_priority.description, name: @va_secretary_priority.name, position: @va_secretary_priority.position, short_name: @va_secretary_priority.short_name } }
    assert_redirected_to va_secretary_priority_url(@va_secretary_priority)
  end

  test "should destroy va_secretary_priority" do
    assert_difference('VaSecretaryPriority.count', -1) do
      delete va_secretary_priority_url(@va_secretary_priority)
    end

    assert_redirected_to va_secretary_priorities_url
  end
end
