require 'rails_helper'

RSpec.describe Role, type: :model do
  subject(:role) { described_class.new }

  describe 'associations' do
    it { is_expected.to have_and_belong_to_many(:users).join_table(:users_roles) }
    it { is_expected.to belong_to(:page_group).class_name('PageGroup').optional }
    it { is_expected.to belong_to(:resource).optional }
  end

  describe 'validations' do
    it do
      expect(role).to validate_inclusion_of(:resource_type)
                   .in_array(Rolify.resource_types)
                   .allow_nil
    end
  end

  describe 'database columns' do
    it { is_expected.to have_db_column(:resource_type).of_type(:string) }
    it { is_expected.to have_db_column(:resource_id).of_type(:integer) }
  end
end
