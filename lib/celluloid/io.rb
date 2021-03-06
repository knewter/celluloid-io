require 'celluloid/io/version'

require 'celluloid'
require 'celluloid/io/dns_resolver'
require 'celluloid/io/mailbox'
require 'celluloid/io/reactor'
require 'celluloid/io/stream'

require 'celluloid/io/tcp_server'
require 'celluloid/io/tcp_socket'
require 'celluloid/io/udp_socket'
require 'celluloid/io/unix_server'
require 'celluloid/io/unix_socket'

require 'celluloid/io/ssl_server'
require 'celluloid/io/ssl_socket'

module Celluloid
  # Actors with evented IO support
  module IO
    def self.included(klass)
      klass.send :include, Celluloid
      klass.mailbox_class Celluloid::IO::Mailbox
    end

    def self.evented?
      actor = Thread.current[:celluloid_actor]
      actor && actor.mailbox.is_a?(Celluloid::IO::Mailbox)
    end

    def wait_readable(io)
      io = io.to_io
      if IO.evented?
        mailbox = Thread.current[:celluloid_mailbox]
        mailbox.reactor.wait_readable(io)
      else
        Kernel.select([io])
      end
      nil
    end
    module_function :wait_readable

    def wait_writable(io)
      io = io.to_io
      if IO.evented?
        mailbox = Thread.current[:celluloid_mailbox]
        mailbox.reactor.wait_writable(io)
      else
        Kernel.select([], [io])
      end
      nil
    end
    module_function :wait_writable
  end
end
