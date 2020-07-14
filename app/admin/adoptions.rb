ActiveAdmin.register_page "Adoptions" do
  content do
    para "Hello World"
  end

  controller do
    before_action :hello_world
    def hello_world
      @practices = Practice.all
      @adoptions = DiffusionHistory.all
    end
  end

  content do
    h1 'Adoptions by practice'

    practices.each do |p|
      panel "#{p.name}" do
        "#{p.diffusion_histories.exists? ? h4('Adoption Facilities') : para('No Adoptions recorded for this practice')}"
        adoptions.where(practice: p).each do |a|
          para "#{a.facility_id}"
        end
      end
    end
  end
end