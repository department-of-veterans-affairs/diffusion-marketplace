class PracticeOriginFacilities < ApplicationController
  def new

  end

  def create

  end

  def initialize (practice_id, facility_id, facility_type, initiating_department_office_id)
    @practice_id = practice_id
    @facility_id = facility_id
    @facility_type = facility_type
    @initiating_department_office_id = initiating_department_office_id
  end
end