class <%= class_name.underscore.camelize %> < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string   :name
    end

    create_table :pages do |t|
      t.string   :link
      t.string   :menu
      t.string   :url
      t.string   :page_type
      t.string   :layout,         :null => false, :default => 'application'
      t.integer  :pagination,     :null => true
      t.integer  :node_id
      t.integer  :user_id
      t.integer  :view_group_id
      t.integer  :edit_group_id
      t.integer  :parent_id
      t.integer  :lft
      t.integer  :rgt
      t.boolean  :nav_main

      t.timestamps
    end
    add_index(:pages, [:lft, :rgt])

    create_table :snippets do |t|
      t.string   :name
      t.text     :content

      t.timestamps
    end

    create_table :nodes do |t|
       t.string  :title
       t.text    :content
       t.string  :preview
       t.string  :type
       t.integer :user_id
       t.integer :page_id
       t.integer :meta_id

       t.timestamps
    end

    create_table :config do |t|
      t.string   :name
      t.string   :value
    end

    create_table :meta do |t|
      t.string   :author
      t.string   :keywords
      t.string   :description
      t.string   :copyright
      t.string   :robots
    end
  end

  def self.down
    drop_table   :groups
    drop_table   :pages
    drop_table   :snippets
    drop_table   :nodes
    drop_table   :config
    drop_table   :meta
  end
end
