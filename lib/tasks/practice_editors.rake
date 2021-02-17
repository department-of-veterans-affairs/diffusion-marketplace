namespace :practice_editors do
  desc 'Adds practice owner to the list of practice editors for their practice'
  task add_practice_owners_to_practice_editors: :environment do
    practices = Practice.all

    practices.each do |practice|
      if practice.user.present? && practice.practice_editors.where(user: practice.user).empty?
        PracticeEditor.create!(practice: practice, user: practice.user, email: practice.user.email)
      end
    end

    puts "A practice editor has been created for every practice that has an owner!!"
  end
end


