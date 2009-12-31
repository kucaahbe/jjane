# User model
class JJaneUser < ActiveRecord::Base
  set_table_name :users

  acts_as_authentic

  validates_presence_of :name, :group_id

  belongs_to :group, :class_name => 'JJaneGroup'
end
