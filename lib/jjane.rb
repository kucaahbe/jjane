module JJane
  VERSION="0.0.3"

  class <<self
    def boot_log msg
      puts "=> [JJane] " + msg
    end

    def booted
      puts "=> ....................................."
    end
  end
end

JJane.boot_log "#{JJane::VERSION} starting"
require 'jjane/rails_config'
require 'jjane/routing_extensions'
require 'jjane/logger'
require 'jjane/editor_config'
JJane.boot_log "loaded."
JJane.booted
