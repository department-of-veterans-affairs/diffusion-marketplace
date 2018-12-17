require 'test_helper'

class ImpactCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @impact_category = impact_categories(:one)
  end

  test "should get index" do
    get impact_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_impact_category_url
    assert_response :success
  end

  test "should create impact_category" do
    assert_difference('ImpactCategory.count') do
      post impact_categories_url, params: { impact_category: { description: @impact_category.description, name: @impact_category.name, parent_category_id: @impact_category.parent_category_id, position: @impact_category.position, short_name: @impact_category.short_name } }
    end

    assert_redirected_to impact_category_url(ImpactCategory.last)
  end

  test "should show impact_category" do
    get impact_category_url(@impact_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_impact_category_url(@impact_category)
    assert_response :success
  end

  test "should update impact_category" do
    patch impact_category_url(@impact_category), params: { impact_category: { description: @impact_category.description, name: @impact_category.name, parent_category_id: @impact_category.parent_category_id, position: @impact_category.position, short_name: @impact_category.short_name } }
    assert_redirected_to impact_category_url(@impact_category)
  end

  test "should destroy impact_category" do
    assert_difference('ImpactCategory.count', -1) do
      delete impact_category_url(@impact_category)
    end

    assert_redirected_to impact_categories_url
  end
end
