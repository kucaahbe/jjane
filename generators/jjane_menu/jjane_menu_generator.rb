class JjaneMenuGenerator < Rails::Generator::NamedBase

  attr_reader :menu_name

  def initialize(runtime_args, runtime_options = {})
    super
    @menu_name  =  @name.underscore
    @class_name =  "AddMenu#{@class_name}ToPages"
    @singular_name = @class_name.underscore
  end

  def manifest
    record do |m|
      m.migration_template 'migration.rb', 'db/migrate'
    end
  end
end
