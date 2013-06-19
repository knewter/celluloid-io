# Debugging JRuby SSLSocket hanger

- bundle exec rspec spec/celluloid/io/ssl_socket_spec.rb:72
- this will hang when the ssl_client.connect in with_ssl_sockets
- That goes into C::IO::SSLSocket#connect, which calls wait_readable
- That just calls Celluloid::IO.wait_readable(self)
- https://github.com/celluloid/celluloid-io/commit/bd5d556ac51affeaff6a8933d01e657d8ae57b18#L0L21
- ^ is prolly the commit that introduced this, and roughly the location...but I'll keep digging in like I am
- so....on to Celluloid::IO.wait_readable
