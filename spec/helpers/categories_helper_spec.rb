require 'rails_helper'

RSpec.describe 'CategoriesHelper', type: :helper do
  describe '#get_most_popular_categories' do
    before do
      parent_category1 = create(:category, name: 'Parent Category 1')
      parent_category2 = create(:category, name: 'Parent Category 2')

      category1 = create(:category, name: 'Category 1', parent_category: parent_category1)
      category2 = create(:category, name: 'Category 2', parent_category: parent_category1)
      category3 = create(:category, name: 'Category 3', parent_category: parent_category2)
      category4 = create(:category, name: 'Category 4', parent_category: parent_category2)
      create(:category, name: 'Category 5', parent_category: parent_category2)

      admin = create(:user, :admin)
      ahoy_visit = create(:ahoy_visit, user: admin)

      5.times { create(:ahoy_event, visit: ahoy_visit, properties: { category_id: category1.id.to_s }, time: 45.days.ago) }
      4.times { create(:ahoy_event, visit: ahoy_visit, properties: { category_id: category4.id.to_s }, time: 60.days.ago) }
      3.times { create(:ahoy_event, visit: ahoy_visit, properties: { category_id: category3.id.to_s }, time: 30.days.ago) }
      2.times { create(:ahoy_event, visit: ahoy_visit, properties: { category_id: category2.id.to_s }, time: 30.days.ago) }
    end

    it 'returns the most popular categories based on Ahoy::Event records within the last 90 days' do
      popular_categories = helper.get_most_popular_categories
      expect(popular_categories).to eq(['Category 1', 'Category 4', 'Category 3', 'Category 2', 'Category 5'])
    end
  end
end