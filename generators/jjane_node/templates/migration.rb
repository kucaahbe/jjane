class <%= class_name.underscore.camelize %> < ActiveRecord::Migration
  def self.up
    create_table :nodes do |t|
      t.string :title
      t.text :content
      t.integer :page_id
      t.integer :user_id
      #      t.integer :file_id

      t.timestamps
    end

  end

  def self.down
    drop_table   :nodes
  end
end
