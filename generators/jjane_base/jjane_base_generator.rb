class JjaneBaseGenerator < Rails::Generator::NamedBase

  def initialize(runtime_args, runtime_options = {})
    runtime_args[0]='CreateJJaneBaseTables'
    super
  end

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
      m.file 'views/login_form.html.erb', File.join('app','views','login','welcome.html.erb')
      # views for users controller
      m.file 'views/users/edit.html.erb', File.join('app','views','users','edit.html.erb')
      m.file 'views/users/_form.html.erb', File.join('app','views','users','_form.html.erb')
      m.file 'views/users/index.html.erb', File.join('app','views','users','index.html.erb')
      m.file 'views/users/new.html.erb', File.join('app','views','users','new.html.erb')
      m.file 'views/users/show.html.erb', File.join('app','views','users','show.html.erb')

      # base migration
      m.migration_template 'migration.rb', 'db/migrate'
    end
  end

  private

  def controllers
    %w[ admin crud login pages site snippets attached_files users ]
  end

  def models
    %w[ user_session user ]
  end
end
