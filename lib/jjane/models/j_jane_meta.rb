# Model for meta tags(table meta_info)
class JJaneMeta < ActiveRecord::Base
  set_table_name 'meta'

  # return all defined meta tags for site,to define meta tag just add column with
  # needed name to table 'meta'
  def self.tags
    column_names - ['id','owner_id']
  end

  # returns content for given name
  def content(name)
    name = name.to_sym
    self.send name if self.respond_to?(name)
  end
end
