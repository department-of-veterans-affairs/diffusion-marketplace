class PortMilestonesToTimelineMilestone < ActiveRecord::Migration[5.2]
  def change
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
  end
end