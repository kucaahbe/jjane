class JjaneBaseGenerator < Rails::Generator::NamedBase

  def initialize(runtime_args, runtime_options = {})
    runtime_args[0]='CreateJjaneBaseTables'
    super
  end

  def manifest
    record do |m|
      m.directory File.join('app','views','pages','static')
      m.directory File.join('app','views','login')

      # css and main layout
      m.file 'notices.css', File.join('public','stylesheets','notices.css')
      m.file 'application.html.erb', File.join('app','views','layouts','application.html.erb')

      # files for default static page
      m.file 'static_edit.html.erb', File.join('app','views','pages','static','_edit.html.erb')
      m.file 'static_show.html.erb', File.join('app','views','pages','static','show.html.erb')

      # files for login controller
      for controller in controllers do
	m.file "#{controller}_controller.rb", File.join('app','controllers',"#{controller}_controller.rb")
      end
      for model in models do
	m.file "#{model}_model.rb", File.join('app','models',"#{model}.rb")
      end
      m.file 'login_form.html.erb', File.join('app','views','login','welcome.html.erb')

      # base migration
      m.migration_template 'migration.rb', 'db/migrate'
    end
  end

  private

  def controllers
    %w[ login site snippets pages ]
  end

  def models
    %w[ user_session snippet meta ]
  end
end
