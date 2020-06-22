module PracticesHelper
  SATISFACTION_LABELS = ['Little or no impact', 'Some impact', 'Significant impact', 'High or large impact'].freeze
  COST_LABELS = ['0-$10,000', '$10,000-$50,000', '$50,000-$250,000', 'More than $250,000'].freeze
  DIFFICULTY_LABELS = ['Little or no difficulty to implement', 'Some difficulty to implement', 'Significant difficulty to implement', 'High or large difficulty to implement'].freeze
  TIME_ESTIMATE_OPTIONS =['1 week', '1 month', '3 months', '6 months', '1 year', 'longer than 1 year', 'Other (Please specify)']

  COMPLEXITY_LABELS = ['Little or no complexity', 'Some complexity', 'Significant complexity', 'High or large complexity'].freeze

  # TODO: what to do with these?
  # def gold_status_first_line
  #   gold_status_tagline.split('\n')[0]
  # end
  #
  # def gold_status_second_line
  #   gold_status_tagline.split('\n')[1]
  # end

  # chooses the highest rating of difficulty, sustainability, and number of departments
  def complexity_aggregate(practice)
    [practice.difficulty_aggregate || 0, practice.sustainability_aggregate || 0, practice.number_departments || 0].max
  end

  def departments_required_display(practice)
    one_to_three_departments = (1..3)
    department_count = practice.number_departments
    case
    when one_to_three_departments.cover?(department_count)
      return "#{department_count.humanize} department#{department_count == 1 ? '' : 's'}".humanize
    when department_count == 0
      return 'None'
    else
      return 'Four or more departments'
    end
  end

  def duration_of_job_display(practice)
    durations = practice.additional_staffs.map { |as| as.duration_in_weeks&.downcase }
    durations.include?('permanent') ? 'Permanent' : "#{durations.map { |d| d.to_i }.sum} weeks" if durations.any?
  end

  def offices_for_select
    @office_data = JSON.parse(File.read("#{Rails.root}/lib/assets/practice_origin_office_lookup.json"))
    @office_data = @office_data["departments"][0]["offices"]
    #@office_data.map {|c| [ c['name']['label'], c['id']['id'].to_i ] }
    debugger
    format.json {render json: @office_data.map{|office| {:id => office.id, :name =>  office.name} }}

  end
end
