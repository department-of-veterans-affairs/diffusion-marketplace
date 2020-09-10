namespace :port_milestones_to_timelines do
  desc "Ports milestone descriptions to Timeline.milestone field in line break delimited list"
  task port_milestones_to_timelines: :environment do
    tl_ids = Array.new
    Milestone.all.each do |ms|
      if(!tl_ids.include?(ms.timeline_id))
        tl_ids.push(ms.timeline_id)
        tl_milestone = "";
        cur_tl_id = ms.timeline_id
        Milestone.all.where(timeline_id: cur_tl_id.to_s).each do |d|
          if d.description.length != 0
            tl_milestone += d.description + "\r\n"
          end
        end
        tl = Timeline.find_by(id: ms.timeline_id.to_s)
        tl.milestone = tl_milestone
        tl.save
      end
    end
    puts "All milestones have been ported to Timelines.milestone field."
  end
end