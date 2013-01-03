module Tassadar
  module Server
    class Whitelist
      def initialize(app, addresses)
        @app = app
        @whitelist = addresses
      end

      def call(env)
        if white_listed?(env)
          @app.call(env)
        else
          [ 403,
            { 'Content-Type' => 'text/plain; charset=utf-8' },
            Array( "IP #{env['REMOTE_ADDR']} is not whitelisted" )
          ]
        end
      end

      def remote_ip(env)
        if env.include? 'HTTP_X_FORWARDED_FOR'
          env['HTTP_X_FORWARDED_FOR']
        else
          env['REMOTE_ADDR']
        end
      end
      
      def white_listed?(env)
        @whitelist.include? remote_ip(env)
      end
    end
  end
end