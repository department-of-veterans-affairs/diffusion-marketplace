namespace :shark_tank_practices do
  desc "Assign the Shark Tank badge to past Shark Tank winners"

  task assign_shark_tank_badge: :environment do
    shark_tank_badge = Badge.find_by({name: 'Shark Tank'})

    shark_tank_winner_slugs = [
        'healthier-kidneys-through-your-kitchen',
        'whoopsafe',
        'geri-vet',
        'preoperative-frailty-screening-prehabilitation',
        'gerofit',
        'video-blood-pressure-visits',
        'veterans-mental-evaluation-team-vmet',
        'virtual-claims-clinic',
        'telerehab-wheeled-mobility-clinic-to-cnh',
        'jumpstart-new-hire-onboarding-program',
        'dedicated-environmental-services-training-specialist',
        'suicide-alert-red-card',
        'increasing-access-to-primary-care-using-pharmacist-providers',
        '4-sight',
        'caring-for-older-adults-and-caregivers-at-home-coach',
        'copd-care',
        'rn-stay-interviews-a-nurse-retention-strategy',
        'project-happen',
        'utilizing-machine-learning-uml',
        'advanced-comprehensive-diabetes-care-acdc',
        'environmental-management-service-ems',
        'vha-rapid-naloxone',
        'national-telewound-care-practice',
        'the-stride-program',
        'my-life-my-story',
        'vione',
        'flow3'
    ]
    shark_tank_winner_slugs.each do |stws|
      shark_tank_practice = Practice.find_by(slug: stws)
      if !shark_tank_practice.nil?
        BadgePractice.create!({practice: shark_tank_practice, badge: shark_tank_badge})
      else
        puts "The slug #{stws} does not exist"
      end
    end
    puts "All past Shark Tank winners now have the Shark Tank Badge!!"
  end
end