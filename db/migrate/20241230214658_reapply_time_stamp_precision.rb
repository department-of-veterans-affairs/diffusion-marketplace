class ReapplyTimeStampPrecision < ActiveRecord::Migration[7.0]
  def change
    change_column :homepage_features, :created_at, :datetime, precision: 6
    change_column :homepage_features, :updated_at, :datetime, precision: 6
    change_column :homepages, :created_at, :datetime, precision: 6
    change_column :homepages, :updated_at, :datetime, precision: 6
    change_column :page_event_components, :created_at, :datetime, precision: 6
    change_column :page_event_components, :updated_at, :datetime, precision: 6
    change_column :page_block_quote_components, :created_at, :datetime, precision: 6
    change_column :page_block_quote_components, :updated_at, :datetime, precision: 6
    change_column :page_one_to_one_image_components, :created_at, :datetime, precision: 6
    change_column :page_one_to_one_image_components, :updated_at, :datetime, precision: 6
    change_column :page_publication_components, :created_at, :datetime, precision: 6
    change_column :page_publication_components, :updated_at, :datetime, precision: 6
    change_column :page_simple_button_components, :created_at, :datetime, precision: 6
    change_column :page_simple_button_components, :updated_at, :datetime, precision: 6
    change_column :page_triple_paragraph_components, :created_at, :datetime, precision: 6
    change_column :page_triple_paragraph_components, :updated_at, :datetime, precision: 6
    change_column :page_two_to_one_image_components, :created_at, :datetime, precision: 6
    change_column :page_two_to_one_image_components, :updated_at, :datetime, precision: 6
    change_column :products, :created_at, :datetime, precision: 6
    change_column :products, :updated_at, :datetime, precision: 6
    change_column :va_facilities, :created_at, :datetime, precision: 6
    change_column :va_facilities, :updated_at, :datetime, precision: 6
    change_column :visns, :created_at, :datetime, precision: 6
    change_column :visns, :updated_at, :datetime, precision: 6
  end
end
