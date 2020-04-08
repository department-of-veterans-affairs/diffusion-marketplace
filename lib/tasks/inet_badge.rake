namespace :inet_badge do
  desc "Add iNET badge to current iNET practices"

  task add_inet_badge: :environment do
    inet_badge_id = Badge.find_by(name: 'iNET').id
    inet_practice_slugs = [
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
    inet_practice_slugs.each do |ips|
      inet_practice = Practice.find_by(slug: ips)
      if !inet_practice.nil?
        BadgePractice.create({practice_id: inet_practice.id, badge_id: inet_badge_id})
      else
        puts "The slug #{ips} does not exist"
      end
    end
    puts "All current iNET practices now have an iNET badge!!"
  end
end