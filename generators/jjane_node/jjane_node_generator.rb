class JjaneNodeGenerator < ScaffoldGenerator

  attr_reader :node_name,
              :node_table_name

  def initialize(runtime_args, runtime_options = {})
    runtime_args[0] = "nodes/#{runtime_args[0]}"
    @default_fields = [
       'title:string',
       'content:text',
       'page_id:integer',
       'user_id:integer'
    ]
    super
    @node_name = @singular_name
    @node_table_name = @plural_name
    logger.info runtime_args.inspect
    logger.info runtime_options.inspect
  end

  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions("#{controller_class_name}Controller", "#{controller_class_name}Helper")
      m.class_collisions(class_name)

      # Controller, helper, views, test and stylesheets directories.
      m.directory(File.join('app/models', class_path))
      m.directory(File.join('app/controllers', controller_class_path))
      m.directory(File.join('app/views', controller_class_path, controller_file_name))

      for view in node_views
	m.template(
	  "view_#{view}.html.erb",
	  File.join('app/views', controller_class_path, controller_file_name, "#{view}.html.erb")
	)
      end

      m.template(
	'controller.rb', File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")
      )

      #      m.route_resources controller_file_name
      m.dependency 'model', [node_name] + @default_fields + @args, :collision => :skip, :skip_fixture => true
      m.template 'model.rb', File.join('app/models',class_path,"#{node_name}.rb"), :collision => :force

    end
  end

  protected

  def node_views
    %w[ new _form edit ]
  end
end
