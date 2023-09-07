namespace :practice do
  desc "Update diffusion histories counts"
  task update_diffusion_histories_counts: :environment do
    Practice.find_each do |practice|
      Practice.reset_counters(practice.id, :diffusion_histories)
    end
  end
end
