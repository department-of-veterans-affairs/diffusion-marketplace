require 'test_helper'

class JobPositionCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @job_position_category = job_position_categories(:one)
  end

  test "should get index" do
    get job_position_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_job_position_category_url
    assert_response :success
  end

  test "should create job_position_category" do
    assert_difference('JobPositionCategory.count') do
      post job_position_categories_url, params: { job_position_category: { description: @job_position_category.description, name: @job_position_category.name, parent_category_id: @job_position_category.parent_category_id, position: @job_position_category.position, short_name: @job_position_category.short_name } }
    end

    assert_redirected_to job_position_category_url(JobPositionCategory.last)
  end

  test "should show job_position_category" do
    get job_position_category_url(@job_position_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_job_position_category_url(@job_position_category)
    assert_response :success
  end

  test "should update job_position_category" do
    patch job_position_category_url(@job_position_category), params: { job_position_category: { description: @job_position_category.description, name: @job_position_category.name, parent_category_id: @job_position_category.parent_category_id, position: @job_position_category.position, short_name: @job_position_category.short_name } }
    assert_redirected_to job_position_category_url(@job_position_category)
  end

  test "should destroy job_position_category" do
    assert_difference('JobPositionCategory.count', -1) do
      delete job_position_category_url(@job_position_category)
    end

    assert_redirected_to job_position_categories_url
  end
end
