class SnippetsController < CrudController
  uses_tiny_mce :options => TinyMCEconfig.load, :only => [:new,:edit,:create,:update]

  set_model Snippet
end
