require 'authlogic'
module JJane
  module Models
    # User model
    class User < ActiveRecord::Base
      validates_presence_of :name, :role

      acts_as_authentic
    end
  end
end
