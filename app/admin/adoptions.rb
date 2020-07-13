ActiveAdmin.register_page "Adoptions" do
  content do
    para "Hello World"
  end

  controller do
    before_action :hello_world
    def hello_world
      @practices = Practice.all
    end
  end

  content do
    panel 'Practice Engagement & Adoption' do
      h4 do
        "Favorited Counts"
      end
      table_for practices, id: 'adopted_stats' do
        column(:name)
      end
    end
    # table_for practices, id: 'adopted_stats' do
    #   column("#{date_headers[:current]}") {|ps| ps[:adopted_this_month]}
    #   column("Last Month") {|ps| ps[:adopted_one_month_ago]}
    #   column :total_adopted
    # end
  end
end