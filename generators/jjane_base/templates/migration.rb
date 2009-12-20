class <%= class_name.underscore.camelize %> < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string   :link
      t.string   :title
      t.string   :desc
      t.string   :url
      t.string   :_type_,      :null => false
      t.string   :_layout_,    :null => false, :default => 'application'
      t.text     :content,     :null => true 
      t.integer  :pagination,                  :default => 5
      t.integer  :parent_id
      t.integer  :lft
      t.integer  :rgt
      t.string   :nav

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
       t.integer :page_id
       t.integer :user_id
    end

    create_table :config, :id => false do |t|
      t.string   :name
      t.string   :value
    end
  end

  def self.down
    drop_table   :pages
    drop_table   :snippets
  end
end
