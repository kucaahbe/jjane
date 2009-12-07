class JjaneBaseGenerator < Rails::Generator::NamedBase

  def initialize(runtime_args, runtime_options = {})
    runtime_args[0]='CreateJjaneBaseTables'
    super
  end

  def manifest
    record do |m|
      m.directory File.join('app','views','pages','static')
      m.directory File.join('app','views','login')

      # files for default static page
      m.file 'static_edit.html.erb', File.join('app','views','pages','static','_edit.html.erb')
      m.file 'static_show.html.erb', File.join('app','views','pages','static','show.html.erb')

      # files for login controller
      m.file 'login_controller.rb', File.join('app','controllers','login_controller.rb')
      m.file 'user_session_model.rb', File.join('app','models','user_session.rb')
      m.file 'login_form.html.erb', File.join('app','views','login','welcome.html.erb')

      #TODO file for site controller
      #
      # base migration
      m.migration_template 'migration.rb', 'db/migrate'
    end
  end
end
