require 'rails_helper'
require_relative '../../app/services/save_practice_service.rb'

RSpec.describe SavePracticeService do
  describe 'when save_practice errors' do
    before do
      user = User.create!(email: 'test@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
      practice = Practice.create!(name: 'A public practice', tagline: 'Test tagline', initiating_facility: '687HA', date_initiated: Date.new(2011, 12, 31), summary: 'practice summary', support_network_email: 'fake-support-email@example.com', user: user)
      @save_practice = SavePracticeService.new({ practice: practice, practice_params: {}})
    end

    context 'while update_department_practices' do
      it 'returns a StandardError' do
        allow(@save_practice).to receive(:update_department_practices).and_raise(StandardError.new('Error!!!'))

        result = @save_practice.save_practice
        expect(result.is_a?(StandardError)).to eq true
        expect(result.message).to eq 'error updating departments'
      end
    end

    context 'while remove_attachments' do
      it 'returns a StandardError' do
        allow(@save_practice).to receive(:remove_attachments).and_raise(StandardError.new('Error!!!'))

        result = @save_practice.save_practice
        expect(result.is_a?(StandardError)).to eq true
        expect(result.message).to eq 'error removing attachments'
      end
    end

    context 'while remove_main_display_image' do
      it 'returns a StandardError' do
        allow(@save_practice).to receive(:remove_main_display_image).and_raise(StandardError.new('Error!!!'))

        result = @save_practice.save_practice
        expect(result.is_a?(StandardError)).to eq true
        expect(result.message).to eq 'error removing practice thumbnail'
      end
    end

    context 'while crop_main_display_image' do
      it 'returns a StandardError' do
        allow(@save_practice).to receive(:crop_main_display_image).and_raise(StandardError.new('Error!!!'))

        result = @save_practice.save_practice
        expect(result.is_a?(StandardError)).to eq true
        expect(result.message).to eq 'error cropping practice thumbnail'
      end
    end
  end

  describe 'when save_practice succeeds' do
    before do
      @user = User.create!(email: 'test2@va.gov', password: 'Password123', password_confirmation: 'Password123', skip_va_validation: true, confirmed_at: Time.now, accepted_terms: true)
      @practice = Practice.create!(name: 'A public practice 2', tagline: 'Test tagline', initiating_facility: '687HA', date_initiated: Date.new(2011, 12, 31), summary: 'practice summary', support_network_email: 'fake-support-email@example.com', main_display_image: File.new("#{Rails.root}/spec/assets/charmander.png"), user: @user)
    end

    context 'while crop_main_display_image' do
      it 'returns true' do
        practice_params = {
          crop_x: 50,
          crop_y: 10,
          crop_w: 50,
          crop_h: 10
        }
        save_practice = SavePracticeService.new({ practice: @practice, practice_params: practice_params})

        result = save_practice.save_practice
        expect(result).to eq true
      end
    end
  end
end
