namespace :risk_and_mitigation do
  desc "Removes risks and mitigations for risk entries that do not have a corresponding mitigation AND removes mitigations with no corresponding risk."

  task remove_unpaired_risks_and_mitigation: :environment do
    risk_join_array = Array.new
    miti_join_array = Array.new
    m_items_to_delete = Array.new
    r_items_to_delete = Array.new

    all_mitigations = Mitigation.all
    all_risks = Risk.all

    all_mitigations.each do |m|
      miti_join_array.push(m.risk_mitigation_id)
    end

    all_risks.each do |r|
      risk_join_array.push(r.risk_mitigation_id)
    end

  miti_join_array.each do |m_id|
     if  !risk_join_array.include?(m_id)
      m_items_to_delete.push(m_id)
    end
  end
  risk_join_array.each do |r_id|
   if !miti_join_array.include?(r_id)
      r_items_to_delete.push(r_id)
    end
  end

   if m_items_to_delete.length > 0
       m_items_to_delete.each do |d|
           Mitigation.where(risk_mitigation_id: d).destroy_all
          RiskMitigation.find_by_id(d).destroy
      end
   end

  if r_items_to_delete.length > 0
      r_items_to_delete.each do |d|
        Risk.where(risk_mitigation_id: d).destroy_all
        RiskMitigation.find_by_id(d).destroy
      end
  end
    puts "All unpaired risks and mitigations have been removed."
  end
end