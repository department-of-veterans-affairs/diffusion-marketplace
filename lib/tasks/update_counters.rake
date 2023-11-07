namespace :practice do
  desc "Update diffusion histories counts"
  task update_diffusion_histories_counts: :environment do
    Practice.find_each do |practice|
      Practice.reset_counters(practice.id, :diffusion_histories)

      updated_practice = Practice.find(practice.id)
      puts "Practice ID #{updated_practice.id} - Updated diffusion histories count: #{updated_practice.diffusion_histories_count}"
    end
  end
end
