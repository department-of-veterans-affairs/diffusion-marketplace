# frozen_string_literal: true

class ChecklistFile < ApplicationRecord
  acts_as_list scope: :practice
  has_attached_file :attachment
  do_not_validate_attachment_file_type :attachment
  belongs_to :practice
end
