require 'rails_helper'

RSpec.describe NavbarHelper, type: :helper do
  let(:user) { nil }

  let(:published_public_page_group) { create(:page_group) }
  let(:published_public_page) { create(:page, page_group: published_public_page_group, slug: 'home', is_public: true, published: Time.zone.now) }

  let(:non_published_non_public_page_group) { create(:page_group) }
  let(:non_published_non_public_page) { create(:page, page_group: non_published_non_public_page_group, slug: 'home', is_public: false, published: nil) }

  let(:published_non_public_page_group) { create(:page_group) }
  let(:published_non_public_page) { create(:page, page_group: published_non_public_page_group, slug: 'home') }

  let(:public_non_published_page_group) { create(:page_group) }
  let(:public_non_published_page) { create(:page, page_group: public_non_published_page_group, slug: 'home', is_public: true, published: nil) }

  let(:page_group_ids) {
    [
      published_public_page.id,
      non_published_non_public_page.id,
      published_non_public_page.id,
      public_non_published_page.id
    ]
   }

  before do
    allow(PageGroup).to receive(:community).and_return(PageGroup.where(id: page_group_ids))
  end

  describe "#communities_with_home_hash" do
    subject(:community_hash) { helper.communities_with_home_hash(user) }

    context "when user is nil" do
      it "returns hash of public and published page groups" do
        expect(community_hash[published_public_page_group.name]).to eq(published_public_page_group.slug)
        expect(community_hash.count).to eq(1)
      end

      it "does not include page groups with unpublished home pages" do
        published_public_page.update(published: nil)
        expect(community_hash).to be_empty
      end

      it "does not include page groups with published but non-public home pages" do
        published_public_page.update(is_public: false, published: Time.zone.now)
        expect(community_hash).to be_empty
      end
    end

    context "when user is an admin" do
      let(:user) { create(:user) }

      before { user.add_role(:admin) }

      it "returns all page groups regardless of publication status" do
        expect(community_hash[published_public_page_group.name]).to eq(published_public_page_group.slug)
        expect(community_hash["#{non_published_non_public_page_group.name} - Preview"]).to eq(non_published_non_public_page_group.slug)
        expect(community_hash[published_non_public_page_group.name]).to eq(published_non_public_page_group.slug)
        expect(community_hash["#{public_non_published_page_group.name} - Preview"]).to eq(public_non_published_page_group.slug)
      end
    end

    context "when user is an editor but not admin" do
      let(:user) { create(:user) }
      let(:non_published_non_public_page_group_b) { create(:page_group) }
      let(:non_published_non_public_page_b) { create(:page, page_group: non_published_non_public_page_group_b, slug: 'home', is_public: false, published: nil) }

      before do
        user.add_role(:page_group_editor, non_published_non_public_page_group)
        user.add_role(:page_group_editor, public_non_published_page_group)
      end

      it "returns own editable unpublished page groups and published page_groups" do
        expect(community_hash[published_public_page_group.name]).to eq(published_public_page_group.slug)
        expect(community_hash["#{non_published_non_public_page_group.name} - Preview"]).to eq(non_published_non_public_page_group.slug)
        expect(community_hash[published_non_public_page_group.name]).to eq(published_non_public_page_group.slug)
        expect(community_hash["#{public_non_published_page_group.name} - Preview"]).to eq(public_non_published_page_group.slug)
      end

      it "doesn't return unpublished page_groups user is not an editor for" do
        expect(community_hash).not_to include(non_published_non_public_page_group_b.name)
        expect(community_hash).not_to include("#{non_published_non_public_page_group_b.name} - Preview")
      end
    end
  end
end
