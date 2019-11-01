class AddVerifiedImplementerAndTeamMemberToUserPractice < ActiveRecord::Migration[5.2]
  def change
    add_column :user_practices, :verified_implementer, :boolean, default: false
    add_column :user_practices, :team_member, :boolean, default: false
  end
end
