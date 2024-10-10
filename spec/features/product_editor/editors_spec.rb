describe 'Product editor - Editors', type: :feature do
  let!(:product) { create(:product) }
  let!(:user) { create(:user) }
  let!(:admin) { create(:user, :admin) }

  before do
    login_as(current_user, scope: :user, run_callbacks: false)
  end

  describe 'when logged in as a regular user' do
    let(:current_user) { user }

    context 'with no permissions' do
      it 'redirects to the root path with a warning' do
        visit product_editors_path(product)
        expect(page).to have_current_path('/')
        expect(page).to have_content('You are not authorized to view this content.')
      end
    end
  end

  describe 'when logged in as an admin' do
    let(:current_user) { admin }

    it 'allows access and displays the product editors form' do
      visit product_editors_path(product)
      expect(page).to have_selector('h1', text: 'Editors')
    end

    context 'Adding and managing editors' do
      describe 'Adding a new editor successfully' do
        before do
          allow(PracticeEditorMailer).to receive(:invite_to_edit).and_return(double("mailer", deliver: true))
        end

        it 'adds the editor and shows a confirmation message' do
          visit product_editors_path(product)
          fill_in 'Provide va.gov email of the individual who can help you edit this Innovation Page.', with: user.email
          click_button 'Send Invitation'

          expect(PracticeEditorMailer).to have_received(:invite_to_edit).with(product, anything)
          expect(page).to have_content("Editor was added to the list. Product was successfully updated.")
          within('.editors') do
            expect(page).to have_content(user.email)
          end
        end
      end

      describe 'Adding an editor who is already on the list' do
        before { product.practice_editors.create(user: user, email: user.email) }

        it 'displays an error message' do
          visit product_editors_path(product)
          fill_in 'Provide va.gov email of the individual who can help you edit this Innovation Page.', with: user.email
          click_button 'Send Invitation'

          expect(page).to have_content("A user with the email \"#{user.email}\" is already an editor for this product")
        end
      end

      describe 'Removing an existing editor' do
        let!(:editor) { product.practice_editors.create(user: user, email: user.email) }
        let(:user2) { create(:user) }
        let!(:editor2) { product.practice_editors.create(user: user2, email: user2.email) }

        it 'removes the editor and shows a confirmation message' do
          visit product_editors_path(product)
          accept_confirm("Are you sure you want to remove #{user.email} from the editors list?") do
            find("a#delete-practice-editor-#{editor.id}").click
          end

          expect(page).to have_content("Editor was removed from the list. Product was successfully updated.")
          within('.editors') do
            expect(page).not_to have_content(user.email)
          end
        end
      end

      describe 'Attempting to remove the last editor' do
        let!(:editor) { product.practice_editors.create(user: user, email: user.email) }

        it 'shows an error message and keeps the editor in the list' do
          visit product_editors_path(product)
          accept_confirm("Are you sure you want to remove #{user.email} from the editors list?") do
            find("a#delete-practice-editor-#{editor.id}").click
          end

          expect(page).to have_content("At least one editor is required")
          within('.editors') do
            expect(page).to have_content(user.email)
          end
        end
      end
    end
  end

  describe 'when not logged in' do
    let(:current_user) { nil }

    context 'without login' do
      it 'redirects to the login page' do
        visit product_editors_path(product)
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end
end
