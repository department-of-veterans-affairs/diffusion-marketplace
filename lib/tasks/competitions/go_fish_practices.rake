namespace :go_fish_practices do
  desc "Assign the Go Fish badge to certain practices"

  task assign_go_fish_badge: :environment do
    go_fish_badge = Badge.find_by({name: 'Go Fish'})

    go_fish_practice_slugs = [
        'healthier-kidneys-through-your-kitchen',
        'geri-vet',
        'cards-for-connection',
        'pride-in-all-who-served-reducing-healthcare-disparities-for-lgbt-veterans',
        'transcending-self-therapy-integrative-cognitive-behavioral-treatment'
    ]
    go_fish_practice_slugs.each do |gfps|
      go_fish_practice = Practice.find_by(slug: gfps)
      if !go_fish_practice.nil?
        BadgePractice.create!({practice: go_fish_practice, badge: go_fish_badge})
      else
        puts "The slug #{gfps} does not exist"
      end
    end
    puts "All Go Fish practices now have a Go Fish Badge!!"
  end
end