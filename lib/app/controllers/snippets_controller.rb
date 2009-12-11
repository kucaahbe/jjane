class SnippetsController < JJane::Controllers::Crud
  uses_tiny_mce :config => TinyMCEconfig.load, :only => [:new, :edit, :create, :update]
  set_model Snippet

  def index
    logger.info self.class.instance_variables.inspect
    super
  end
end
