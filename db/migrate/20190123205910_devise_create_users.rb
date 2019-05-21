# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      t.timestamps null: false

      ## Additional fields
      t.string  :job_title
      t.string  :first_name
      t.string  :last_name
      t.string  :phone_number
      t.integer :visn

      t.datetime  :password_changed_at
      t.boolean   :skip_va_validation,  null: false, default: false
      t.boolean   :disabled,            null: false, default: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :password_changed_at
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :unlock_token,         unique: true


    create_table :old_passwords do |t|
      t.string :encrypted_password, null: false
      t.string :password_archivable_type, null: false
      t.integer :password_archivable_id, null: false
      t.string :password_salt # Optional. bcrypt stores the salt in the encrypted password field so this column may not be necessary.
      t.datetime :created_at
    end

    add_index :old_passwords, [:password_archivable_type, :password_archivable_id], name: :index_password_archivable
  end
end
