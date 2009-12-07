module JJane
  module Models
    class Snippet < ActiveRecord::Base
      validates_presence_of :name
      validates_uniqueness_of :name
    end
  end
end
