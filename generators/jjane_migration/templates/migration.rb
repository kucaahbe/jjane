class <%= class_name.underscore.camelize %> < ActiveRecord::Migration
  def self.up
<%#
#    create_table :config do |t|
#      t.string   :key
#      t.string   :value
#    end

#    create_table :nodes do |t|
#      t.string :title
#      t.text :content
#      t.integer :page_id
#      t.integer :user_id
#      t.integer :file_id
#
#      t.timestamps
#    end
-%>
    create_table :pages do |t|
      t.string :name
      t.string :title
      t.string :desc
      t.string :link
      t.string :url
      t.string :_type_,   :null => false
      t.string :_layout_, :null => false, :default => 'application'
      t.text   :content,  :null => true 
      t.integer :pagination,              :default => 5
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.boolean :nav_main

      t.timestamps
    end
    add_index(:pages, [:lft, :rgt])

    create_table :snippets do |t|
      t.string   :name
      t.text     :content

      t.timestamps
    end

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
<%#
    drop_table   :config
    drop_table   :nodes
-%>
    drop_table   :pages
    drop_table   :snippets
    drop_table   :users
  end
end
