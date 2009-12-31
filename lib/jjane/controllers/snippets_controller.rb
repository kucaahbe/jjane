class SnippetsController < CrudController

  uses_tiny_mce :config => TinyMCEconfig.load, :only => [:new, :edit, :create, :update]

  set_model Snippet
end