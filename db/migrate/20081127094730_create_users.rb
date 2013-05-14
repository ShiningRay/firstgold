class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :login,                     :string, :limit => 40, :null => false
      t.column :name,                      :string, :limit => 100, :default => '', :null => true
      t.column :email,                     :string, :limit => 100, :null => false
      t.column :crypted_password,          :string, :limit => 40, :null => false
      t.column :salt,                      :string, :limit => 40, :null => false
      t.column :created_at,                :datetime, :null => false
      t.column :updated_at,                :datetime, :null => false
      t.column :remember_token,            :string, :limit => 40
      t.column :remember_token_expires_at, :datetime
      t.column :activation_code,           :string, :limit => 40
      t.column :activated_at,              :datetime
      t.column :state,                     :string, :null => :no, :default => 'passive'
      t.column :deleted_at,                :datetime
      t.column :profile,                   :text
    end
    add_index :users, :login, :unique => true
    add_index :users, :state
    add_index :users, :activation_code, :unique => true
    add_index :users, :email, :unique => true
  end

  def self.down
    drop_table "users"
  end
end
#INSERT INTO `users` (`id`, `login`, `name`, `email`, `crypted_password`, `salt`, `created_at`, `updated_at`, `remember_token`, `remember_token_expires_at`, `activation_code`, `activated_at`, `state`, `deleted_at`) VALUES
#(1, 'shiningray', '', 'tsowly@hotmail.com', '7758446b9f7d432f21415c2da83abaa9043ecedb', 'ac783dff35f689931a3988a4c19540cadbb7e043', '2008-11-30 13:09:42', '2008-11-30 13:09:42', NULL, NULL, NULL, '2008-11-30 21:13:21', 'active', NULL);
