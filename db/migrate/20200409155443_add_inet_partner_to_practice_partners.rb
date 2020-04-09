class AddInetPartnerToPracticePartners < ActiveRecord::Migration[5.2]
  def change
    iNet = PracticePartner.find_by(slug: 'vha-innovators-network')
    unless iNet
      PracticePartner.create!({name: 'VHA Innovators Network', short_name: 'iNET', description: 'The VHA Innovators Network (iNET) is a network of 33 VA medical centers changing the way employees think and solve problems through training and accelerated operationalizing innovation.', slug: 'vha-innovators-network'})
    end

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
        PracticePartnerPractice.create!({practice_id: inet_practice.id, practice_partner_id: iNet.id})
      else
        puts "The slug #{ips} does not exist"
      end
    end
  end
end
