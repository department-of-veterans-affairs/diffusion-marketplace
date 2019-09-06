namespace :diffusion_history do
  # rails diffusion_history:happen
  desc 'Set up database'
  task :happen => :environment do
    happen = Practice.find_by_slug('project-happen')
  end
end