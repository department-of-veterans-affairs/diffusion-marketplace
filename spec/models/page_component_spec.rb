require 'rails_helper'

RSpec.describe PageComponent, type: :model do
  let(:component) { create(:page_header2_component) }
  let(:page_component) { create(:page_component, component: component) }

  describe 'associations' do
    it { is_expected.to belong_to(:page).optional }

    it 'belongs to a polymorphic component with autosave enabled' do
      association = described_class.reflect_on_association(:component)

      expect(association.polymorphic?).to be(true)
      expect(association.options[:autosave]).to be(true)
    end
  end

  describe '#destroy_component' do
    it 'destroys the associated component after PageComponent is destroyed' do
      component_id = page_component.component_id
      component_type = page_component.component_type

      page_component.destroy

      expect { component_type.constantize.find(component_id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
