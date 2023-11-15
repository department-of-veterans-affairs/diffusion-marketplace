require 'rails_helper'

RSpec.describe PracticeResourcesController, type: :controller do
  describe 'GET #download' do
    context 'when accessing the download action' do
      let(:practice_resource) { create(:practice_resource) } 
      it 'redirects to a URL that includes the attachment path' do
        get :download, params: { 
          practice_id: practice_resource.practice.id, 
          id: practice_resource.id, 
          resource_type: practice_resource.class.to_s 
        }

        expect(response).to redirect_to(
          /\/system\/practice_resources\/attachments\/.*\/original\/dummy.pdf\?.*/
        )
      end

      it 'redirects for a PracticeProblemResource' do
        problem_resource = create(:practice_problem_resource)
        get :download, params: { 
          practice_id: problem_resource.practice.id, 
          id: problem_resource.id, 
          resource_type: problem_resource.class.to_s 
        }

        expect(response).to redirect_to(
          /\/system\/practice_problem_resources\/attachments\/.*\/original\/dummy.pdf\?.*/
        )
      end

      it 'redirects for a PracticeResultsResource' do
        results_resource = create(:practice_results_resource)
        get :download, params: { 
          practice_id: results_resource.practice.id, 
          id: results_resource.id, 
          resource_type: results_resource.class.to_s 
        }

        expect(response).to redirect_to(
          /\/system\/practice_results_resources\/attachments\/.*\/original\/dummy.pdf\?.*/
        )
      end

      it 'redirects for a PracticeSolutionResource' do
        solution_resource = create(:practice_solution_resource)
        get :download, params: { 
          practice_id: solution_resource.practice.id, 
          id: solution_resource.id, 
          resource_type: solution_resource.class.to_s 
        }

        expect(response).to redirect_to(
          /\/system\/practice_solution_resources\/attachments\/.*\/original\/dummy.pdf\?.*/
        )
      end

      it 'returns a 404 status if the practice is not found' do
        get :download, params: { 
          practice_id: 'nonexistent', 
          id: practice_resource.id, 
          resource_type: practice_resource.class.to_s 
        }

        expect(response).to have_http_status(:not_found)
      end

      it 'returns a 404 status if the resource is not found' do
        get :download, params: { 
          practice_id: practice_resource.practice.id, 
          id: 'nonexistent', 
          resource_type: practice_resource.class.to_s 
        }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
