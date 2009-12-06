class <%= class_name.underscore.camelize %> < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string   :name
      t.string   :login
      t.string   :email
      t.string   :role
      t.string   :crypted_password
      t.string   :password_salt
      t.string   :persistence_token

      t.timestamps
    end

  end

  def self.down
    drop_table   :users
  end
end
