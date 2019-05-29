ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Recent Practices" do
          table_for Practice.published.order("id desc").limit(10) do
            column("Name") { |practice| link_to(practice.name, admin_practice_path(practice)) }
            column("Support Network email") { |practice| practice.support_network_email }
            column("Created at")   { |practice| practice.created_at }
          end
        end
      end

      column do
        panel "Recent Customers" do
          table_for User.order("id desc").limit(10).each do |_user|
            column(:email)    { |user| link_to(user.email, user_path(user)) }
          end
        end
      end
    end # columns
  end # content
end
