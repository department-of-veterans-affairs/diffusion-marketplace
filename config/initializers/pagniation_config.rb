Rails.application.config.after_initialize do
  if defined?(WillPaginate)
    module WillPaginate
      module ActiveRecord
        module RelationMethods
          alias_method :per, :per_page
          alias_method :num_pages, :total_pages
          alias_method :total_count, :total_entries
        end
      end
    end
  end
end