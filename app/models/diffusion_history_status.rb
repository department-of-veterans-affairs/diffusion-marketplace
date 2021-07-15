class DiffusionHistoryStatus < ApplicationRecord
  belongs_to :diffusion_history

  before_validation :format_unsuccessful_reasons
  validates :status, :diffusion_history_id, presence: :true
  validate :is_valid_unsuccessful_reason
  validate :has_unsuccessful_reasons_other
  before_save :clear_unsuccessful_reasons
  # status strings are In Progress/Complete/Unsuccessful

  ADOPTION_REASONS = {
    0 => 'Lack of sufficient leadership/key stakeholder buy-in',
    1 => 'Centralized decision-making that hinders ability to complete tasks (i.e. bureaucracy)',
    2 => 'Unable to obtain necessary approvals',
    3 => 'Unable to obtain necessary resources',
    4 => 'Unable to attain necessary staff',
    5 => 'Other'
  }

  ADOPTION_REASON_VALUES = ADOPTION_REASONS.keys

  STATUSES = {
    0 => 'Successful',
    1 => 'In-progress',
    2 => 'Unsuccessful'
  }

  def get_status_display_name
    if status === 'Implemented' || status === 'Complete' || status === 'Completed'
      STATUSES[0]
    elsif status === 'Planning' || status === 'In progress' || status === 'Implementing'
      STATUSES[1]
    elsif status === 'Unsuccessful'
      STATUSES[2]
    end
  end

  private

  def clear_unsuccessful_reasons
    if self.get_status_display_name === STATUSES[0] || self.get_status_display_name === STATUSES[1]
      self.unsuccessful_reasons = []
      self.unsuccessful_reasons_other = nil
    end
  end

  def format_unsuccessful_reasons
    if unsuccessful_reasons.present?
      unsuccessful_reasons.map { |ur| ADOPTION_REASON_VALUES.include?(ur.to_i) ? ur.to_i : nil }.compact
    end
  end

  def is_valid_unsuccessful_reason
    if status === 'Unsuccessful'
      if unsuccessful_reasons.present?
        errors.add(:unsuccessful_reasons, "Provided reason for unsuccessful diffusion history is invalid.") if(ADOPTION_REASON_VALUES & unsuccessful_reasons).size != unsuccessful_reasons.size
      else
        errors.add(:unsuccessful_reasons, "Must provide reason for unsuccessful diffusion history.")
      end
    end
  end

  def has_unsuccessful_reasons_other
    other_reason_value = ADOPTION_REASONS.key('Other').to_s.to_i
    if status === 'Unsuccessful' && unsuccessful_reasons&.include?(other_reason_value) && unsuccessful_reasons_other.blank?
      errors.add(:unsuccessful_reasons_other, "Must provide accompanying text for 'Other' reason.")
    end
  end
end
