class JjaneLayoutGenerator < Rails::Generator::NamedBase

  def manifest
    record do |m|
      m.directory File.join('app','views','layouts')

      # css and layout
      m.file 'layout.html.erb', File.join('app','views','layouts',"#{name}.html.erb"), :collision => :skip
      m.file 'layout.css', File.join('public','stylesheets',"#{name}.css"), :collision => :skip
    end
  end
end
