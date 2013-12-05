$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'tassadar-server'
require 'rack/static'

use Rack::Config do |env|
  env['api.tilt.root'] = File.join(
    File.dirname(__FILE__), 'lib', 'tassadar', 'server', 'views'
  )
end

if ENV['REDIS_URL']
  require 'redis'
  $redis = Redis.new url: ENV['REDIS_URL']
end

if ENV['WHITELIST']
  require 'tassadar/server/whitelist'
  use Tassadar::Server::Whitelist,
    ENV['WHITELIST'].split(',').delete_if(&:empty?)
end

if ENV['THROTTLE']
  require 'tassadar/server/throttle'
  use Tassadar::Server::Throttle,
    max: ENV['THROTTLE'].to_i,
    cache: $redis,
    key_prefix: :throttle
end

run Rack::Cascade.new [
  Tassadar::Server::API,
  Rack::Static.new(self,
    urls: ['/'],
    root: ::File.join(::File.dirname(__FILE__), 'public'),
    index: 'index.html'
  )
]
