require 'rails_helper'

RSpec.describe AdminAuthAdapter, type: :model do
  let(:page_group) { create(:page_group) }
  let(:page) { create(:page, page_group: page_group) }
  let(:user) { create(:user) }
  let(:practice) { create(:practice) }
  let(:subjects) { [page, user, page_group, practice] }

  describe "#authorized?" do
    context "when the user is an admin" do
      let(:admin) { create(:user, :admin) }
      let(:adapter) { described_class.new(nil, admin) }

      it "returns true for any action and subject" do
        subjects.each do |subject|
          expect(check_authorization(adapter, :read, subject)).to be true
          expect(check_authorization(adapter, :update, subject)).to be true
          expect(check_authorization(adapter, :edit, page)).to be true
          expect(check_authorization(adapter, :destroy, page)).to be true
          expect(check_authorization(adapter, :delete, page)).to be true
        end
      end
    end

    context "when the user is a page group editor" do
      let(:editor) { create(:user) }
      let(:adapter) { described_class.new(nil, editor) }

      it "returns false for any action and subject" do
        editor.add_role(:page_group_editor, page_group)

        subjects.each do |subject|
          expect(check_authorization(adapter, :read, subject)).to be false
          expect(check_authorization(adapter, :update, subject)).to be false
          expect(check_authorization(adapter, :edit, page)).to be false
          expect(check_authorization(adapter, :destroy, page)).to be false
          expect(check_authorization(adapter, :delete, page)).to be false
        end
      end
    end

    context "when the user has no specific roles" do
      let(:user_without_roles) { create(:user) }
      let(:adapter) { described_class.new(nil, user_without_roles) }

      it "returns false for all actions on pages" do
        subjects.each do |subject|
          expect(check_authorization(adapter, :read, subject)).to be false
          expect(check_authorization(adapter, :update, subject)).to be false
          expect(check_authorization(adapter, :edit, page)).to be false
          expect(check_authorization(adapter, :destroy, page)).to be false
          expect(check_authorization(adapter, :delete, page)).to be false
        end
      end
    end
  end

  def check_authorization(adapter, action, subject)
    adapter.authorized?(action, subject)
  end
end
