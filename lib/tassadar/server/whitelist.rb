module Tassadar
  module Server
    class Whitelist
      def initialize(app, addresses)
        @app = app
        @whitelist = addresses
      end

      def call(env)
        if !!(content_type(env) =~ /json/)
          if white_listed?(env)
            @app.call(env)
          else
            [ 403,
              { 'Content-Type' => 'text/plain; charset=utf-8' },
              Array( "IP #{remote_ip(env)} is not whitelisted" )
            ]
          end
        else
          @app.call(env)
        end
      end

      def content_type(env)
        Rack::Request.new(env).content_type
      end

      def remote_ip(env)
        Rack::Request.new(env).ip
      end
      
      def white_listed?(env)
        @whitelist.include? remote_ip(env)
      end
    end
  end
end
