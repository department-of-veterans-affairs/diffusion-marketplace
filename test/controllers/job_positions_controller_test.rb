require 'test_helper'

class JobPositionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @job_position = job_positions(:one)
  end

  test "should get index" do
    get job_positions_url
    assert_response :success
  end

  test "should get new" do
    get new_job_position_url
    assert_response :success
  end

  test "should create job_position" do
    assert_difference('JobPosition.count') do
      post job_positions_url, params: { job_position: { description: @job_position.description, job_position_category_id: @job_position.job_position_category_id, name: @job_position.name, position: @job_position.position, short_name: @job_position.short_name } }
    end

    assert_redirected_to job_position_url(JobPosition.last)
  end

  test "should show job_position" do
    get job_position_url(@job_position)
    assert_response :success
  end

  test "should get edit" do
    get edit_job_position_url(@job_position)
    assert_response :success
  end

  test "should update job_position" do
    patch job_position_url(@job_position), params: { job_position: { description: @job_position.description, job_position_category_id: @job_position.job_position_category_id, name: @job_position.name, position: @job_position.position, short_name: @job_position.short_name } }
    assert_redirected_to job_position_url(@job_position)
  end

  test "should destroy job_position" do
    assert_difference('JobPosition.count', -1) do
      delete job_position_url(@job_position)
    end

    assert_redirected_to job_positions_url
  end
end
