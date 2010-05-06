class AddPublishingInfo < ActiveRecord::Migration
  def self.up
    change_table :nodes do |t|
      t.column :start_publishing, :datetime
      t.column :end_publishing,   :datetime
    end
  end

  def self.down
    change_table :nodes do |t|
      t.remove :start_publishing
      t.remove :end_publishing
    end
  end
end
