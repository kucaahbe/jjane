class JJane
  class <<self
    def boot_log msg
      puts "=> [JJane] " + msg
    end

    def booted
      puts "=> ....................................."
    end

    def get_version
      version_file = File.new File.join(File.dirname(__FILE__),'..','VERSION'), 'r'
      version_string = version_file.gets.chop
    rescue
      'unstable-dev'
    end
  end

  VERSION=JJane.get_version
end

JJane.boot_log "#{JJane::VERSION} starting"
require 'jjane/rails_config'
require 'jjane/routing_extensions'
require 'jjane/logger'
require 'jjane/editor_config'
JJane.boot_log "loaded."
JJane.booted
