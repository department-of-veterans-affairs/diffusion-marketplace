class Role < ApplicationRecord
  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :page_group, class_name: 'PageGroup', foreign_key: 'resource_id',
              inverse_of: :editor_roles, optional: true


  belongs_to :resource,
             :polymorphic => true,
             :optional => true


  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify
end
