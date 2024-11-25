namespace :practice do
  desc "Get data metrics for a practice"
  task metrics: :environment do
    # Step 1: Identify the practice
    practice = Practice.find_by(name: "Cards for Connection")
    unless practice
      puts "Practice 'Cards for Connection' not found."
      exit
    end
    practice_id = practice.id

    # Step 2: Ahoy Events
    ahoy_event_count = Ahoy::Event.where("properties->>'practice_id' = ?", practice_id.to_s).count
    ahoy_event_time_range = Ahoy::Event.where("properties->>'practice_id' = ?", practice_id.to_s).pluck(:time).minmax

    # Step 3: Diffusion Histories
    diffusion_history_count = DiffusionHistory.where(practice_id: practice_id).count
    diffusion_history_time_range = DiffusionHistory.where(practice_id: practice_id).pluck(:created_at).minmax

    # Step 4: Adoption Counts by Status (assuming scopes or methods exist)
    adoptions_completed = DiffusionHistory.get_with_practice(practice).get_by_successful_status.size
    adoptions_in_progress = DiffusionHistory.get_with_practice(practice).get_by_in_progress_status.size
    adoptions_unsuccessful = DiffusionHistory.get_with_practice(practice).get_by_unsuccessful_status.size

    # Step 5: VA Facility Details
    associated_facility_count = DiffusionHistory.where(practice_id: practice_id).where.not(va_facility_id: nil).count
    associated_facilities = DiffusionHistory.where(practice_id: practice_id).where.not(va_facility_id: nil).pluck(:va_facility_id).uniq

    # Step 6: Output Results
    puts "Practice: #{practice.name} (ID: #{practice_id})"
    puts "Ahoy Event Count: #{ahoy_event_count}"
    puts "Ahoy Event Time Range: #{ahoy_event_time_range}"
    puts "Diffusion History Count: #{diffusion_history_count}"
    puts "Diffusion History Time Range: #{diffusion_history_time_range}"
    puts "Adoptions Completed: #{adoptions_completed}"
    puts "Adoptions In Progress: #{adoptions_in_progress}"
    puts "Adoptions Unsuccessful: #{adoptions_unsuccessful}"
    puts "Associated VA Facility Count: #{associated_facility_count}"
    puts "Associated VA Facilities: #{associated_facilities}"
  end
end