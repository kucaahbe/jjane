# Install hook code here
puts 'dependency plugin'
`./script/plugin install -qf git://github.com/collectiveidea/awesome_nested_set.git`
puts 'copy files'
`rake jjane:copy_files`
