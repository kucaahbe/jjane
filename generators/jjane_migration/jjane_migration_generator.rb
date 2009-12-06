class JjaneMigrationGenerator < MigrationGenerator
  def initialize(runtime_args, runtime_options = {})
    runtime_args[0] = 'create_jjane_tables'
    super
  end

  def manifest
    record do |m|
      m.migration_template 'migration.rb', 'db/migrate', :assigns => get_local_assigns
    end
  end
end
