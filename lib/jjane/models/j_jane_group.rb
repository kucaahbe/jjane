class JJaneGroup < ActiveRecord::Base
  set_table_name 'groups'
  validates_presence_of   :name
  validates_uniqueness_of :name
  has_many :users, :class_name => 'JJaneUser', :foreign_key => 'group_id'
end
