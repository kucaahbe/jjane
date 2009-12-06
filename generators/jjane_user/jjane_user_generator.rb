class JjaneUserGenerator < Rails::Generator::NamedBase

  def initialize(runtime_args, runtime_options = {})
    runtime_args[0]='CreateJjaneUsers'
    super
  end

  def manifest
    record do |m|
      m.migration_template 'migration.rb', 'db/migrate'
    end
  end


  protected

  def banner
    "Usage: #{$0} #{spec.name}"
  end
end
