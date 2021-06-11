class UpdateCategoryGroupings < ActiveRecord::Migration[5.2]
  def change
    #enable_extension 'pgcrypto'

    strategic_rec = Category.create(name: 'Strategic', short_name: 'strategic', description: 'Categories on strategical domains',
                                  position: Category.maximum(:position).next, created_at: Time.now,
                                  updated_at: Time.now, is_other: false)

    strategy_id = strategic_rec.id
    clinical_rec = Category.find_by(name: 'Clinical')
    clinical_id = clinical_rec.id
    operational_rec = Category.find_by(name: 'Operational')
    operational_id = operational_rec.id

    Category.update_all(parent_category_id: nil)


    Category.find_each do |cat|
      if cat.name = 'Access to Care' || 'Age-Friendly' || 'COVID-19' || 'Employee Experience' || 'Health Equity' || 'High Reliability' || 'Moving Forward' || 'Suicide Prevention'
        cat.update(parent_category_id: strategy_id)
      elsif cat.name = 'Building Management' || 'Contracting' || 'Healthcare Administration' || 'Information Technology' || 'Logistics' || 'Veterans Benefits' || 'Workforce Development'
        cat.update(parent_category_id: operational_id)
        #elsif cat.name =
      end
    end





    debugger
    raise Exception
      #say strategy_id
    # execute <<-SQL
    #   select id into clinical_id from categories where name = 'Clinical';
    #   select id into operational_id from categories where name = 'Operational';
    #   output id
    #   debugger

      # INSERT INTO categories (name, short_name, description, position, parent_category_id, created_at, updated_at, related_terms, is_other)
      #             VALUES ('Strategic', 'strategic', 'Categories on strategical domains', (SELECT MAX(position)+1 FROM categories), null, now(), now(), null, false);
      # set @strategy_id = SELECT SCOPE_IDENTITY();
      


      
      # UPDATE page_components SET component_uuid = page_header_components.uuid
      # FROM page_header_components WHERE page_components.component_id = page_header_components.id;
      #
      # UPDATE page_components SET component_uuid = page_header2_components.uuid
      # FROM page_header2_components WHERE page_components.component_id = page_header2_components.id;
      #
      # UPDATE page_components SET component_uuid = page_paragraph_components.uuid
      # FROM page_paragraph_components WHERE page_components.component_id = page_paragraph_components.id;
      #
      # UPDATE page_components SET component_uuid = page_subpage_hyperlink_components.uuid
      # FROM page_subpage_hyperlink_components WHERE page_components.component_id = page_subpage_hyperlink_components.id;
      #
      # UPDATE page_components SET component_uuid = page_practice_list_components.uuid
      # FROM page_practice_list_components WHERE page_components.component_id = page_practice_list_components.id;
    #SQL

    # execute "ALTER TABLE page_header_components ADD PRIMARY KEY (id);"
    # execute "ALTER TABLE page_header2_components ADD PRIMARY KEY (id);"
    # execute "ALTER TABLE page_paragraph_components ADD PRIMARY KEY (id);"
    # execute "ALTER TABLE page_subpage_hyperlink_components ADD PRIMARY KEY (id);"
    # execute "ALTER TABLE page_practice_list_components ADD PRIMARY KEY (id);"
    #
    # add_index :page_components, :position
  end
end