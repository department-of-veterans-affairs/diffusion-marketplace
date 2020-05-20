class Page < ApplicationRecord
  belongs_to :page_group
  has_many :page_components, -> {order(position: :asc)}, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :page_components, allow_destroy: true
  validates :slug, presence:true, length:{minimum: 8}
  validates :title, presence:true, length:{minimum: 5}
  validates :description, presence:true, length:{minimum: 10}
  validates_uniqueness_of :slug
end
