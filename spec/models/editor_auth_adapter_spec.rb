require 'rails_helper'

RSpec.describe EditorAuthAdapter, type: :model do
  let(:page_group) { create(:page_group) }
  let(:page) { create(:page, page_group: page_group) }


  describe "#authorized?" do
    context "when the user is an admin" do
      let(:admin) { create(:user, :admin) }
      let(:adapter) { described_class.new(nil, admin) }

      it "returns true for any action and subject" do
        expect(adapter.authorized?(:read, page)).to be true
        expect(adapter.authorized?(:update, page)).to be true
      end
    end

    context "when the user is a page group editor" do
      let(:editor) { create(:user) }
      let(:adapter) { described_class.new(nil, editor) }

      it "returns true for reading pages" do
        editor.add_role(:page_group_editor, page_group)
        expect(adapter.authorized?(:read, page)).to be true
      end
    end

    context "when the user has no specific roles" do
      let(:user) { create(:user) }
      let(:adapter) { described_class.new(nil, user) }

      it "returns false for all actions on pages" do
        expect(adapter.authorized?(:read, page)).to be false
        expect(adapter.authorized?(:update, page)).to be false
      end
    end
  end
end