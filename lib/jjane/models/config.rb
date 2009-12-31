class JJaneConfig < ActiveRecord::Base
  set_table_name 'config'
  serialize :value
  validates_uniqueness_of :name

  #   Config['param_name'] returns value of param_name
  def self.[](name)
    find_by_name(name).value
  rescue
    nil
  end

  #   Config['param_name']=something sets parameter
  def self.[]=(name,value)
    record = self.find_by_name(name)
    record.update_attribute(:value,value)
  rescue
    create!(:name => name, :value => value)
  end
end
