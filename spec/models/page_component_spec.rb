require 'rails_helper'

RSpec.describe PageComponent, type: :model do
  let(:component) { create(:page_header2_component) }
  let(:page_component) { create(:page_component, component: component) }
  let(:invalid_component) { build(:page_block_quote_component, text: nil, citation: nil) } # Assumes both fields are required and being nil makes the component invalid

  let(:page_component_with_invalid_component) do
    build(:page_component, component: invalid_component)
  end

  describe 'associations' do
    it { is_expected.to belong_to(:page).optional }

    it 'belongs to a polymorphic component with autosave enabled' do
      association = described_class.reflect_on_association(:component)

      expect(association.polymorphic?).to be(true)
      expect(association.options[:autosave]).to be(true)
    end
  end


  describe 'validations' do
    context 'with an invalid associated component' do
      it 'is not valid' do
        expect(page_component_with_invalid_component).not_to be_valid
      end

      it 'contains error messages from the associated component' do
        page_component_with_invalid_component.valid? # Triggers validation
        error_messages = page_component_with_invalid_component.errors.full_messages.to_sentence

        expect(error_messages).to include("PageComponent Block Quote errors:")
        expect(error_messages).to include("Text can't be blank", "Citation can't be blank")
      end
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

  describe '#custom_component_validation_message' do
    let(:invalid_component) { build(:page_block_quote_component, text: nil, citation: nil) }
    let(:page_component_with_invalid_component) { build(:page_component, component: invalid_component) }

    before do
      page_component_with_invalid_component.valid? # Triggers validation
    end

    it 'adds custom validation error messages to the PageComponent' do
      error_messages = page_component_with_invalid_component.errors[:component]

      expect(error_messages).not_to be_empty
      expect(error_messages.first).to include("PageComponent Block Quote errors:")
      expect(error_messages.first).to include("Text can't be blank", "Citation can't be blank")
    end
  end
end
