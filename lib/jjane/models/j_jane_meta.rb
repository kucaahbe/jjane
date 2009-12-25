# Model for meta tags(table meta_info)
class JJaneMeta < ActiveRecord::Base
  set_table_name 'meta_info'

  def self.tags
    column_names - ['id','owner_id']
  end
end
