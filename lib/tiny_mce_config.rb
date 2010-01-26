class TinyMCEconfig
  DEFAULT_SETTINGS = {
    :external_image_list_url => "myexternallist.js"
  }
  def self.load(config='default')
    config = File.open(File.join(RAILS_ROOT, 'config', "tiny_mce_config_#{config}.yml"))
    YAML::load(config)
  rescue
    {}
  end
end
