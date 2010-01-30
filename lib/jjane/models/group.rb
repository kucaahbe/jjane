class Group < ActiveRecord::Base#:nodoc:
  validates_presence_of   :name
  validates_uniqueness_of :name
  has_many :users
end
