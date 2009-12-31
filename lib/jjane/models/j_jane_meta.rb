# Model for meta tags(table meta_info)
class JJaneMeta < ActiveRecord::Base
  set_table_name 'meta'

  def self.tags
    column_names - ['id','owner_id']
  end

  def content(name)
    name = name.to_sym
    self.send name if self.respond_to?(name)
  end
end
