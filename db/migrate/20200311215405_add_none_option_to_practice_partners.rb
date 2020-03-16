class AddNoneOptionToPracticePartners < ActiveRecord::Migration[5.2]
  def change
    PracticePartner.create({name: 'None of the above, or Unsure'})
  end
end
