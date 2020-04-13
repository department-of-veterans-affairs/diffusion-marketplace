class AddInetPartnerToPracticePartners < ActiveRecord::Migration[5.2]
  def change
    iNet = PracticePartner.find_by(slug: 'vha-innovators-network')
    unless iNet
      PracticePartner.create!({name: 'VHA Innovators Network', short_name: 'iNET', description: 'The VHA Innovators Network (iNET) is a network of 33 VA medical centers changing the way employees think and solve problems through training and accelerated operationalizing innovation.', slug: 'vha-innovators-network'})
    end

    inet_practice_slugs = [
        'healthier-kidneys-through-your-kitchen',
        'geri-vet',
        'cards-for-connection',
        'pride-in-all-who-served-reducing-healthcare-disparities-for-lgbt-veterans',
        'transcending-self-therapy-integrative-cognitive-behavioral-treatment'
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
