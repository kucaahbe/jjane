require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Unit testing the JJane plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
#  t.pattern = 'test/**/*_test.rb'
  t.pattern = 'test/jjane_test.rb'
  t.verbose = false
end

desc 'Generate documentation for the JJane plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = 'JJane'
  rdoc.options << '--line-numbers' << '--inline-source' << '--charset=utf-8'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.rdoc_files.include('lib/app/**/*.rb')
end
