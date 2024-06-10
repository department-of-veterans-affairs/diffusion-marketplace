require 'rails_helper'

RSpec.describe 'PageGroup Management', type: :feature do
  describe 'Creating a PageGroup' do
    let!(:admin) { create(:user, :admin) }
    let!(:valid_editor) { create(:user) }

    before do
      login_as(admin, scope: :user, run_callbacks: false)
      visit new_admin_page_group_path
    end

    it 'successfully creates a PageGroup with valid details' do
      fill_in 'Name', with: "New Unique Page Group Name"
      fill_in 'Description', with: 'A unique description for the new page group.'
      click_button 'Create Page group'
      expect(page).to have_content('Page group was successfully created.')
      expect(page).to have_content("New Unique Page Group Name")
      expect(page).to have_content('A unique description for the new page group.')
    end

    it 'successfully creates a PageGroup with valid editor emails' do
      fill_in 'Name', with: 'New Page Group'
      fill_in 'Description', with: 'A description for the new page group.'
      fill_in 'Add Community Editor(s)', with: valid_editor.email

      expect {
        click_button 'Create Page group'
      }.to change(PageGroup, :count).by(1)

      new_page_group = PageGroup.last
      expect(new_page_group.reload.editors).to include(valid_editor)
      expect(page).to have_content('Page group was successfully created.')
    end

    it 'fails to create a PageGroup with invalid editor emails and shows an error message' do
      nonexistent_email = "nonexistent@va.gov"
      visit new_admin_page_group_path

      fill_in 'Name', with: 'Failed Page Group'
      fill_in 'Description', with: 'This should not be created.'
      fill_in 'Add Community Editor(s)', with: nonexistent_email

      expect {
        click_button 'Create Page group'
      }.not_to change(PageGroup, :count)

      expect(page).to have_content('User not found with email(s): nonexistent@va.gov')
    end
  end

  describe "Editing a PageGroup's Editors" do
    let!(:admin) { create(:user, :admin) }
    let!(:page_group) { create(:page_group) }
    let!(:editor) { create(:user, email: "editor_email1@va.gov") }
    let!(:existing_editor) { create(:user) }

    before do
      login_as(admin, scope: :user, run_callbacks: false)
    end

    context 'Updating editors' do
      it 'successfully adds an editor to a PageGroup when there were none' do
        visit edit_admin_page_group_path(page_group)

        fill_in 'Name', with: 'Updated Page Group Name'
        fill_in 'Description', with: 'Updated description here.'
        fill_in 'Add Community Editor(s)', with: editor.email

        click_button 'Update Page group'

        expect(page).to have_content('Page group was successfully updated.')
        expect(page_group.reload.editors).to include(editor)
      end

      it "successfully adds an editor to a PageGroup's existing editors" do
        existing_editor = create(:user, email: "editor_email2@va.gov")
        existing_editor.add_role(:page_group_editor, page_group)
        visit edit_admin_page_group_path(page_group)

        fill_in 'Name', with: 'Updated Page Group Name'
        fill_in 'Description', with: 'Updated description here.'
        fill_in 'Add Community Editor(s)', with: "#{existing_editor.email}, #{editor.email}"

        click_button 'Update Page group'

        expect(page).to have_content('Page group was successfully updated.')
        expect(page).to have_content("editor_email1@va.gov")
        expect(page).to have_content("editor_email2@va.gov")
        visit edit_admin_page_group_path(page_group)
        expect(page).to have_content("editor_email1@va.gov")
        expect(page).to have_content("editor_email2@va.gov")
        expect(page_group.editors).to include(editor, existing_editor)
      end

      it "successfully removes an editor from a PageGroup's existing editors" do
        editor.add_role(:page_group_editor, page_group)
        existing_editor.add_role(:page_group_editor, page_group)
        visit edit_admin_page_group_path(page_group)

        within("ul#current-editors") do
          find("li", text: editor.email).find("input[type='checkbox']").set(true)
        end

        click_button 'Update Page group'

        expect(page).to have_content('Page group was successfully updated.')
        expect(page).to have_content(existing_editor.email)
        expect(page).not_to have_content(editor.email)
        visit edit_admin_page_group_path(page_group)
        expect(page).to have_content(existing_editor.email)
        expect(page).not_to have_content(editor.email)
        expect(page_group.reload.editors).to include(existing_editor)
        expect(page_group.reload.editors).not_to include(editor)
      end

      it "successfully removes all editors from a PageGroup's existing editors" do
        editor.add_role(:page_group_editor, page_group)
        existing_editor.add_role(:page_group_editor, page_group)
        visit edit_admin_page_group_path(page_group)

        within("ul#current-editors") do
          all("li").each do |li|
            li.find("input[type='checkbox']").set(true)
          end
        end

        click_button 'Update Page group'

        expect(page).to have_content('Page group was successfully updated.')
        expect(page).not_to have_content(existing_editor.email)
        expect(page).not_to have_content(editor.email)
        visit edit_admin_page_group_path(page_group)
        expect(page).not_to have_content(existing_editor.email)
        expect(page).not_to have_content(editor.email)
        expect(page_group.reload.editors).not_to include(existing_editor)
        expect(page_group.reload.editors).not_to include(editor)
      end

      it 'attempts to update a PageGroup with a nonexistent editor email' do
        nonexistent_email = "nonexistent@va.gov"
        visit edit_admin_page_group_path(page_group)

        fill_in 'Name', with: 'Updated Page Group Name'
        fill_in 'Description', with: 'Updated description for sad path.'
        fill_in 'Add Community Editor(s)', with: nonexistent_email

        click_button 'Update Page group'

        expect(page).to have_content('User not found with email(s): nonexistent@va.gov')
        expect(page_group.reload.editors).not_to include(nonexistent_email)
      end
    end
  end

  describe "Editing a PageGroup's Pages" do
    let!(:admin) { create(:user, :admin) }
    let!(:page_group) { create(:page_group, name: PageGroup::COMMUNITIES.first) }
    let!(:page1) { create(:page, slug: "home", title: "Home Page", page_group: page_group) }
    let!(:page2) { create(:page, slug: "about", title: "About Page", page_group: page_group) }
    let!(:page3) { create(:page, slug: "innovations", title: "Innovations Page", page_group: page_group) }

    before do
      login_as(admin, scope: :user, run_callbacks: false)
    end

    it "displays the page_group's pages in the un-ordered section of 'Pages' section" do
      page_group.pages.each {|page| page.update!(position: nil)}
      visit edit_admin_page_group_path(page_group)

      within("ul.unpositioned-pages") do
        expect(page).to have_content(page1.title)
        expect(page).to have_content(page2.title)
        expect(page).to have_content(page3.title)
      end
    end

    it "displays the page_group's pages in the ordered section of 'Pages' section" do
      visit edit_admin_page_group_path(page_group)

      within("ul#current-pages") do
        expect(page).to have_content(page1.title)
        expect(page).to have_content(page2.title)
        expect(page).to have_content(page3.title)
      end
    end

    it "displays the page_group's pages by short_name in the ordered section of 'Pages' section" do
      page1.update!(short_name: "Community")
      page2.update!(short_name: "About")
      page3.update!(short_name: "Innovations")
      visit edit_admin_page_group_path(page_group)

      within("ul#current-pages") do
        expect(page).to_not have_content(page1.title)
        expect(page).to_not have_content(page2.title)
        expect(page).to_not have_content(page3.title)

        expect(page).to have_content(page1.short_name)
        expect(page).to have_content(page2.short_name)
        expect(page).to have_content(page3.short_name)
      end
    end
  end
end
