namespace :milestones do
  desc "Transfer all milestone entries from timelines model to milestones model"

  task milestones_transfer: :environment do
    timelines = Timeline.all
    timelines.each do |tl|
      Milestone.create({description: tl.milestone, timeline_id: tl.id})
    end
    puts "All current milestones successfully transferred to new milestone model!!"
  end
end