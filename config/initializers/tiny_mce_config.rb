class TinyMCEconfig
  def self.load
    config = File.open(File.join(RAILS_ROOT, 'config', 'tiny_mce_config.yml'))
    YAML::load(config)
  end
end
