class AddDeviseToCustomers < ActiveRecord::Migration[8.0]
  def self.up
    change_table :customers, bulk: true do |t|
      t.string :encrypted_password, null: false, default: ""

      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      t.datetime :remember_created_at
    end

    add_index :customers, :email, unique: true
    add_index :customers, :reset_password_token, unique: true
  end

  def self.down
    remove_index :customers, :email
    remove_index :customers, :reset_password_token

    remove_column :customers, :encrypted_password
    remove_column :customers, :reset_password_token
    remove_column :customers, :reset_password_sent_at
    remove_column :customers, :remember_created_at
  end
end
