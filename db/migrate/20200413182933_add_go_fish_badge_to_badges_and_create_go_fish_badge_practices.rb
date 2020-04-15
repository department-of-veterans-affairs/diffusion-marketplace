class AddGoFishBadgeToBadgesAndCreateGoFishBadgePractices < ActiveRecord::Migration[5.2]
  def change
    go_fish_badge = Badge.find_or_create_by!({name: 'Go Fish'})

    go_fish_practice_slugs = [
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
    go_fish_practice_slugs.each do |gfps|
      go_fish_practice = Practice.find_by(slug: gfps)
      if !go_fish_practice.nil?
        BadgePractice.create!({practice: go_fish_practice, badge: go_fish_badge})
      else
        puts "The slug #{gfps} does not exist"
      end
    end
  end
end
