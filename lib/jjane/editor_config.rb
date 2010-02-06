class TinyMCEconfig
  DEFAULT_SETTINGS = {
    :file_browser_callback => 'jjaneRubyCommander',
    :relative_urls => false,
    :doctype => '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'
  }
  def self.load(config='default')
    config = File.open(File.join(RAILS_ROOT, 'config', "tiny_mce_config_#{config}.yml"))
    YAML::load(config).merge DEFAULT_SETTINGS
  rescue
    {}
  end
end
