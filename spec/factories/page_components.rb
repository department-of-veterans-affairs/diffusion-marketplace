FactoryBot.define do
  factory :page_component do
    association :page

    transient do
      component_type { nil }
      component_attributes { {} }
    end

    component do
      if component_type
        association(component_type.underscore.to_sym, **component_attributes)
      end
    end
  end
end
