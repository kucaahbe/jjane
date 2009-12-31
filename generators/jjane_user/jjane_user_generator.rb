class JjaneUserGenerator < ScaffoldGenerator

  def initialize(runtime_args, runtime_options = {})
    runtime_args=runtime_args.insert(0, 'User')
    @default_fields = [
      "name:string",
      "email:string",
      "group_id:integer",
      "crypted_password:string",
      "password_salt:string",
      "persistence_token:string"
    ]
    super
  end

  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions("#{controller_class_name}Controller", "#{controller_class_name}Helper")
      m.class_collisions(class_name)

      # Controller, helper, views, test and stylesheets directories.
      m.directory(File.join('app/models', class_path))
      m.directory(File.join('app/controllers', controller_class_path))
      m.directory(File.join('app/helpers', controller_class_path))
      m.directory(File.join('app/views', controller_class_path, controller_file_name))

      for action in scaffold_views
        m.template(
          "view_#{action}.html.erb",
          File.join('app/views', controller_class_path, controller_file_name, "#{action}.html.erb")
        )
      end


      m.template(
        'controller.rb', File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")
      )

      m.dependency 'model', [name] + @default_fields + @args, :collision => :skip
      m.file 'model.rb', 'app/models/user.rb', :collision => :force
    end
  end

  protected

  def scaffold_views
    %w[ index show new edit _form ]
  end
end
