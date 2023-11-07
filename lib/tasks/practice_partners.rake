namespace :practice_partners do
  desc "Create/update certain flagship practice partners and apply the 'is_major' flag"

  task :apply_is_major_flag_to_partners => :environment do
    major_partners = [
      { name: 'Caregiver Support Program', slug: 'caregiver-support-program' },
      { name: 'Clinical Pharmacy Practice Office', slug: 'clinical-pharmacy-practice-office' },
      { name: 'Diffusion of Excellence', slug: 'diffusion-of-excellence' },
      { name: 'Geriatrics and Extended Care', slug: 'geriatrics-and-extended-care' },
      { name: 'Healthcare Environment and Facilities Programs', slug: 'healthcare-environment-and-facilities-program' },
      { name: 'Health Services Research & Development', slug: 'health-services-research-development' },
      { name: 'Office of Connected Care', slug: 'office-of-connected-care' },
      { name: 'Office of Construction', slug: 'office-of-construction-and-facilities' },
      { name: 'Office of Nursing Services', slug: 'office-of-nursing-services' },
      { name: 'Office of Rural Health', slug: 'office-of-rural-health' },
      { name: 'Office of Veterans Access', slug: 'office-of-veterans-access-to-care' },
      { name: 'Quality Enhancement Research Initiative', slug: 'quality-enhancement-research-initiative' },
      { name: 'Systems Redesign and Improvement', slug: 'systems-redesign-and-improvement' },
      { name: 'Veterans Experience Office', slug: 'veterans-experience-office' },
      { name: 'VHA Innovators Network', slug: 'vha-innovators-network' },
      { name: 'XR Network', slug: 'xr-network' }
    ]

    major_partners.each do |partner|
      existing_partner = PracticePartner.find_by(slug: partner[:slug])
      new_partner = nil

      if existing_partner.present?
        existing_partner.update(is_major: true)
      else
        new_partner = PracticePartner.create!(name: partner[:name], slug: partner[:slug], is_major: true)
      end

      puts "The \"#{existing_partner.present? ? existing_partner.name : new_partner.name}\" practice partner has been successfully #{existing_partner.present? ? 'updated' : 'created'} and classified as a major partner!!"
    end
  end

  desc 'Adds new practice partners from a list created in 2022'
  task :add_new_practice_partners => :environment do
    new_practice_partners_json = JSON.parse(File.read("#{Rails.root}/lib/assets/practice_partners.json"))
    failed_partner_creations = []

    new_practice_partners_json.each do |npp|
      partner_name = npp['Name']
      existing_practice_partner = PracticePartner.find_by(name: partner_name)

      if existing_practice_partner.nil?
        begin
          PracticePartner.create!(name: partner_name)
          puts "SUCCESS: The #{partner_name} practice partner has been created!"
        rescue
          puts "ERROR: Something went wrong. The #{partner_name} practice partner could not be created."
          failed_partner_creations << partner_name
        end
      else
        puts "WARNING: The #{partner_name} practice partner could not be created because a practice partner with the same name already exists in the DB."
      end
    end
    puts "*** The 'add_new_practice_partners' task has been completed! *** \n\n"
    if failed_partner_creations.any?
      puts "Error(s) prevented the following practice partners from being created: "
      failed_partner_creations.each do |fpp|
        puts "-- #{fpp}\n"
      end
    end
  end
end
