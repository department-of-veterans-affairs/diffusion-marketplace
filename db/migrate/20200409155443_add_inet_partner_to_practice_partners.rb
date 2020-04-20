class AddInetPartnerToPracticePartners < ActiveRecord::Migration[5.2]
  def change
    PracticePartner.create!({name: 'VHA Innovators Network', short_name: 'iNET', description: 'The VHA Innovators Network (iNET) is a network of 33 VA medical centers changing the way employees think and solve problems through training and accelerated operationalizing innovation.', slug: 'vha-innovators-network'})
  end
end
