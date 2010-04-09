class JjaneNodeGenerator < ScaffoldGenerator

  attr_reader :node_name,
              :node_table_name

  def initialize(runtime_args, runtime_options = {})
    super
    @node_name = @singular_name
    @node_table_name = @plural_name
  end

  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions("#{controller_class_name}Controller", "#{controller_class_name}Helper")
      m.class_collisions(class_name)

      # Directories.
      m.directory(File.join('app/models', class_path))
      m.directory(File.join('app/controllers', controller_class_path))
      m.directory(File.join('app/views/nodes', controller_class_path, controller_file_name))
      m.directory(File.join('app/views/pages', node_name.pluralize))

      # Controller.
      m.template 'controller.rb', File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")

      # Views.
      for view in node_views
	m.template(
	  "view_#{view}.html.erb",
	  File.join('app/views/nodes', controller_class_path, controller_file_name, "#{view}.html.erb")
	)
      end
      # [views for page]
      m.file 'page_edit.html.erb', File.join('app/views/pages/',node_name.pluralize,'_edit.html.erb')
      m.file 'page_show.html.erb', File.join('app/views/pages/',node_name.pluralize,'show.html.erb')

      # Model.
      m.template 'model.rb', File.join('app/models',class_path,"#{node_name}.rb"), :collision => :force
    end
  end

  protected

  def node_views
    %w[ new _form edit show ]
  end
end
