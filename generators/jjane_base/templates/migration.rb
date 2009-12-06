class <%= class_name.underscore.camelize %> < ActiveRecord::Migration
  def self.up
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
  end

  def self.down
    drop_table   :pages
    drop_table   :snippets
  end
end
