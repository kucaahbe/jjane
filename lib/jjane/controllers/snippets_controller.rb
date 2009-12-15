class SnippetsController < JJaneCrudController

  uses_tiny_mce :config => TinyMCEconfig.load, :only => [:new, :edit, :create, :update]

  set_model JJaneSnippet

  def index
    logger.info self.class.instance_variables.inspect
    super
  end
end
