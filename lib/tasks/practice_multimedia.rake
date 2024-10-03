namespace :practice_multimedia do

  desc 'Transfer/Copy Video Files to Practice Multimedia table'
  task transfer_practice_videos: :environment do
    practices = Practice.all

    practices.each do |p|
      p.video_files.each do |pv|
        puts "#{p.id} - #{p.name} Video #{pv.id}"

        # A not-so-fool-proof way to check if this multimedia video was already created
        # just in case this was ran twice in a row on accident
        multi_photo_exists = p.practice_multimedia.where(link_url: pv.url)

        if !multi_photo_exists.any?
          multimedia = p.practice_multimedia.new(
              resource_type: 'video',
              name: pv.description,
              link_url: pv.url
          )

          multimedia.attachment = pv.attachment
          save_multimedia(p, multimedia)

        else
          puts "already created"
        end

      end
    end
    puts "Practice Videos Transfer complete!"
  end

  def save_multimedia(p, multimedia)
    if multimedia.save
      puts "Created PracticeMultimedia for: #{p.id} - #{p.name}"
    else
      puts "Could not create PracticeMultimedia for: #{p.id} - #{p.name}"
      puts "#{multimedia.errors}"
    end
  end

end
