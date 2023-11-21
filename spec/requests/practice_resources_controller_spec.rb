require 'rails_helper'

RSpec.describe PracticeResourcesController, type: :controller do
  describe 'GET #download' do
    let(:user) { create(:user) }

    context 'when the practice is public' do
      let(:practice_resource) { create(:practice_resource, practice: create(:practice, :public_practice)) }

      it 'redirects to the attachment URL without authentication' do
        get :download, params: { 
          practice_id: practice_resource.practice.id, 
          id: practice_resource.id, 
          resource_type: practice_resource.class.to_s 
        }

        expect(response).to redirect_to(practice_resource.attachment_s3_presigned_url)
      end

      it 'redirects to the attachment URL with authentication' do
        sign_in user
        get :download, params: { 
          practice_id: practice_resource.practice.id, 
          id: practice_resource.id, 
          resource_type: practice_resource.class.to_s 
        }

        expect(response).to redirect_to(practice_resource.attachment_s3_presigned_url)
      end
    end

    context 'when the practice is private' do
      let(:practice_resource) { create(:practice_resource, practice: create(:practice, :private_practice)) }

      it 'redirects to sign in page without authentication' do
        get :download, params: { 
          practice_id: practice_resource.practice.id, 
          id: practice_resource.id, 
          resource_type: practice_resource.class.to_s 
        }

        expect(response).to redirect_to(new_user_session_path)
      end

      it 'redirects to the attachment URL with authentication' do
        sign_in user
        get :download, params: { 
          practice_id: practice_resource.practice.id, 
          id: practice_resource.id, 
          resource_type: practice_resource.class.to_s 
        }

        expect(response).to redirect_to(practice_resource.attachment_s3_presigned_url)
      end
    end

    context 'when the practice is disabled' do
      let(:practice) { create(:practice, published: false, approved: false, enabled: false) }

      context 'with a user who has permission' do
        let(:user_with_permission) { create(:user) }
        let(:practice_resource) { create(:practice_resource, practice: practice) }

        before do
          practice.update(user: user_with_permission)
        end

        it 'redirects to the attachment URL with authentication' do
          sign_in user_with_permission
          get :download, params: { 
            practice_id: practice.id, 
            id: practice_resource.id, 
            resource_type: practice_resource.class.to_s 
          }

          expect(response).to redirect_to(practice_resource.attachment_s3_presigned_url)
        end
      end

      context 'with a user who does not have permission' do
        let(:user_without_permission) { create(:user) }
        let(:practice_resource) { create(:practice_resource, practice: practice) }

        it 'responds with unauthorized' do
          sign_in user_without_permission
          get :download, params: { 
            practice_id: practice.id, 
            id: practice_resource.id, 
            resource_type: practice_resource.class.to_s 
          }

          expect(flash[:warning]).to eq('You are not authorized to view this content.')
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'when the practice or resource is not found' do
      let(:practice) { create(:practice) }

      it 'returns a 404 status if the practice is not found' do
        sign_in user
        get :download, params: { 
          practice_id: 'nonexistent', 
          id: 123, 
          resource_type: 'PracticeResource' 
        }

        expect(response).to have_http_status(:not_found)
        expect(response.body).to include('Practice or Resource not found')
      end

      it 'returns a 404 status if the resource is not found' do
        sign_in user
        get :download, params: { 
          practice_id: practice.id, 
          id: 'nonexistent', 
          resource_type: 'PracticeResource' 
        }

        expect(response).to have_http_status(:not_found)
        expect(response.body).to include('Practice or Resource not found')
      end
    end

    context 'for different types of practice resources' do
      let(:practice) { create(:practice, :public_practice) }

      it 'redirects correctly for a PracticeProblemResource' do
        problem_resource = create(:practice_problem_resource, practice: practice)
        get :download, params: { 
          practice_id: practice.id, 
          id: problem_resource.id, 
          resource_type: problem_resource.class.to_s 
        }

        expect(response).to redirect_to(problem_resource.attachment_s3_presigned_url)
      end

      it 'redirects correctly for a PracticeSolutionResource' do
        solution_resource = create(:practice_solution_resource, practice: practice)
        get :download, params: { 
          practice_id: practice.id, 
          id: solution_resource.id, 
          resource_type: solution_resource.class.to_s 
        }

        expect(response).to redirect_to(solution_resource.attachment_s3_presigned_url)
      end

      it 'redirects correctly for a PracticeResultsResource' do
        results_resource = create(:practice_results_resource, practice: practice)
        get :download, params: { 
          practice_id: practice.id, 
          id: results_resource.id, 
          resource_type: results_resource.class.to_s 
        }

        expect(response).to redirect_to(results_resource.attachment_s3_presigned_url)
      end
    end
  end
end
