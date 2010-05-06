class AddPublishingInfo < ActiveRecord::Migration
  def self.up
    change_table :pages do |t|
      t.column :sort_by,        :string,  :default => 'start_publishing'
      t.column :sort_order_asc, :boolean, :default => false
    end
    change_table :nodes do |t|
      t.column :start_publishing, :datetime
      t.column :end_publishing,   :datetime
    end
    Node.all.each do |node|
      node.start_publishing = node.created_at
      node.save!
    end
  end

  def self.down
    change_table :nodes do |t|
      t.remove :sort_by
      t.remove :sort_order_asc
    end
    change_table :nodes do |t|
      t.remove :start_publishing
      t.remove :end_publishing
    end
  end
end
