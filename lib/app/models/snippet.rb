class Snippet < ActiveRecord::Base #:nodoc:
  validates_presence_of :name
  validates_uniqueness_of :name
end
