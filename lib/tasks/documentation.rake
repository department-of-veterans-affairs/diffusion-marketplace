namespace :documentation do
  desc "transfers all publications (links) and additional documents (files) to core practice resources"
  task port_additional_documents_to_practice_resources: :environment do
    Practice.all.each do |p|
      if p.additional_documents.any?
        p.additional_documents.each do |ad|
          # A not-so-fool-proof way to check if this practice resource was already created
          # just in case this was ran twice in a row on accident
          duplicate_document = p.practice_resources.where(attachment_file_name: ad.attachment_file_name)
          if duplicate_document.empty?
            practice_resource = p.practice_resources.new(
                resource_type: 'core',
                media_type: 'file',
                name: ad.title,
                description: ad.description
            )
            practice_resource.attachment = ad.attachment
            save_resource(p, practice_resource)
          else
            puts "A practice resource already exists with the attachment_file_name #{duplicate_document.first.attachment_file_name}"
          end
        end
      end
    end
    puts "All additional documents have been successfully transferred to core practice resource files!"
  end
  task port_publications_to_practice_resources: :environment do
    Publication.all.each do |pub|
      PracticeResource.find_or_create_by!({
                                              practice_id: pub.practice_id,
                                              link_url: pub.link,
                                              description: pub.description,
                                              name: pub.title,
                                              resource_type: 'core',
                                              media_type: 'link'
                                          })
    end
    puts "All practice publications have been successfully transferred to core practice resource links!"
  end
  def save_resource(p, resource)
    if resource.save
      puts "Created PracticeResource for: #{p.id} - #{p.name}"
    else
      puts "Could not create PracticeResource for: #{p.id} - #{p.name}"
      puts "#{resource.errors}"
    end
  end
end