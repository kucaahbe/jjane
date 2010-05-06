class JjaneBaseGenerator < Rails::Generator::NamedBase
  module GeneratorExtension
    def jjane_migration file
      migration_name = File.basename(file,'.rb').sub(/^\d+_/,'')
      migration_template "migrations/#{file}",
      'db/migrate',
	:migration_file_name => migration_name,
	:assigns => { :migration_class_name => migration_name.camelize }
      sleep 1
    rescue
      logger.info "migration #{migration_name} exists, skipping"
    end
  end

  Rails::Generator::Commands::Create.send  :include, GeneratorExtension
  Rails::Generator::Commands::Destroy.send :include, GeneratorExtension
  Rails::Generator::Commands::List.send    :include, GeneratorExtension

  def manifest
    record do |m|
      m.directory File.join('app','views','pages','static')
      m.directory File.join('app','views','users')
      m.directory File.join('app','views','login')

      # csses and main layout
      m.file 'notices.css', File.join('public','stylesheets','notices.css')
      m.dependency 'jjane_layout', ['application']

      # files for default static page
      m.file 'views/static_edit.html.erb', File.join('app','views','pages','static','_edit.html.erb')
      m.file 'views/static_show.html.erb', File.join('app','views','pages','static','show.html.erb')

      for controller in controllers do
	m.file "controllers/#{controller}_controller.rb", File.join('app','controllers',"#{controller}_controller.rb")
      end
      for model in models do
	m.file "models/#{model}_model.rb", File.join('app','models',"#{model}.rb")
      end
      # views for login controller
      m.file 'views/login/_form.html.erb', File.join('app','views','login','_form.html.erb')
      m.file 'views/login/welcome.html.erb', File.join('app','views','login','welcome.html.erb')
      # views for users controller
      m.file 'views/users/edit.html.erb', File.join('app','views','users','edit.html.erb')
      m.file 'views/users/_form.html.erb', File.join('app','views','users','_form.html.erb')
      m.file 'views/users/index.html.erb', File.join('app','views','users','index.html.erb')
      m.file 'views/users/new.html.erb', File.join('app','views','users','new.html.erb')
      m.file 'views/users/show.html.erb', File.join('app','views','users','show.html.erb')

      # migrations
      case name
      when 'install'
	migration_file_name = "jjane_full_migration"
	migration_class_name = migration_file_name.underscore.camelize
	m.migration_template 'full_migration.rb', 'db/migrate', :migration_file_name => migration_file_name, :assigns => { :migration_class_name => migration_class_name }
      when 'update'
	Dir.glob(File.join(source_path('migrations'),'*.rb')).sort.each do |migration_file|
	  m.jjane_migration File.basename(migration_file)
	end
      end
    end
  end

  private

  def controllers
    %w[ snippets users ]
  end

  def models
    %w[ user_session user ]
  end
end
