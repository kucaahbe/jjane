class <%= controller_class_name %>Controller < JJaneCrudController
  uses_tiny_mce :options => TinyMCEconfig.load, :only => [:new,:edit,:create,:update]

  set_model <%= class_name %>, "<%= node_name %>"
end
