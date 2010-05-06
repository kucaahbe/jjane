class AddPublishingInfo < ActiveRecord::Migration
  def self.up
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
      t.remove :start_publishing
      t.remove :end_publishing
    end
  end
end
