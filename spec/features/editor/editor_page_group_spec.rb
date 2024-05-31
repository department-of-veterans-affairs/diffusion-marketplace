require 'rails_helper'

RSpec.describe 'PageGroup Management', type: :feature, js: true do
  describe 'Editing a PageGroup' do
    let!(:page_group) { create(:page_group) }
    let!(:editor) { create(:user, email: "editor_email1@va.gov") }
    let!(:new_editor) { create(:user, email: "editor_email2@va.gov") }

    before do
      editor.add_role(:page_group_editor, page_group)
      login_as(editor, scope: :user, run_callbacks: false)
    end

    context 'Updating editors' do
      it 'successfully adds an editor to a PageGroup when there were none' do
        visit edit_editor_page_group_path(page_group)
        fill_in 'Add Community Editor(s)', with: new_editor.email
        click_button 'Update Page group'

        expect(page).to have_content('Page group was successfully updated.')
        expect(page).to have_content("editor_email1@va.gov")
        expect(page).to have_content("editor_email2@va.gov")
        expect(page_group.reload.editors).to include(new_editor)
      end

      it "successfully adds an editor to a PageGroup's existing editors" do
        visit edit_editor_page_group_path(page_group)
        fill_in 'Add Community Editor(s)', with: new_editor.email
        click_button 'Update Page group'

        expect(page).to have_content('Page group was successfully updated.')
        expect(page).to have_content("editor_email1@va.gov")
        expect(page).to have_content("editor_email2@va.gov")
        expect(page_group.editors).to include(editor, new_editor)
      end

      it "successfully removes an editor from a PageGroup's existing editors" do
        editor.add_role(:page_group_editor, page_group)
        new_editor.add_role(:page_group_editor, page_group)
        visit edit_editor_page_group_path(page_group)

        within("ul#current-editors") do
          find("li", text: new_editor.email).find("input[type='checkbox']").set(true)
        end

        click_button 'Update Page group'

        expect(page).to have_content('Page group was successfully updated.')
        expect(page).to have_content(editor.email)
        expect(page).not_to have_content(new_editor.email)
        visit edit_editor_page_group_path(page_group)
        expect(page).to have_content(editor.email)
        expect(page).not_to have_content(new_editor.email)
        expect(page_group.reload.editors).to include(editor)
        expect(page_group.reload.editors).not_to include(new_editor)
      end

      it 'attempts to update a PageGroup with a nonexistent editor email' do
        nonexistent_email = "nonexistent@va.gov"
        visit edit_editor_page_group_path(page_group)
        fill_in 'Add Community Editor(s)', with: nonexistent_email
        click_button 'Update Page group'

        expect(page).to have_content('User not found with email(s): nonexistent@va.gov')
        expect(page_group.reload.editors).not_to include(nonexistent_email)
      end
    end
  end
end