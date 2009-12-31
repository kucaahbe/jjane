# User model
class User < ActiveRecord::Base
  acts_as_authentic

  validates_presence_of :name, :group_id

  belongs_to :group
end
