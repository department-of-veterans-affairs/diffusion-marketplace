namespace :inet_partner_practices do
  desc "Assign the iNET partner to certain practices"

  task assign_inet_partner: :environment do
    iNet = PracticePartner.find_by(slug: 'vha-innovators-network')

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
        PracticePartnerPractice.create!({practice: inet_practice, practice_partner: iNet})
      else
        puts "The slug #{ips} does not exist"
      end
    end
    puts "All iNET practices now have the corresponding iNET practice partner assigned to them!!"
  end
end