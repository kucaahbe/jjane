class JJaneSnippet < ActiveRecord::Base
  set_table_name :snippets

  validates_presence_of :name
  validates_uniqueness_of :name
end
