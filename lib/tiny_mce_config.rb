class TinyMCEconfig
  DEFAULT_SETTINGS = {
    :file_browser_callback => 'jjaneRubyCommander'
  }
  def self.load(config='default')
    config = File.open(File.join(RAILS_ROOT, 'config', "tiny_mce_config_#{config}.yml"))
    YAML::load(config).merge DEFAULT_SETTINGS
  rescue
    {}
  end
end
