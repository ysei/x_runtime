# run with : rackup server.ru

require "sinatra/base"
require "#{File.dirname(__FILE__)}/../lib/x_runtime"

# redis-server version must > 2.6.0 for lua script.
 
class Server < Sinatra::Base
  # use XRuntime::Middleware, 10, Redis.connect(:url => "redis://localhost:6380/")
  # XRuntime::Middleware is same as Rack::XRuntime
  use Rack::XRuntime, Redis.connect(:url => "redis://localhost:6379/"), :threshold => 30.0, :cache => 50, :expire => 60
  
  get '/probe' do
    XRuntime::Utils.probe(headers)
    sleep rand(0.9)
    XRuntime::Utils.probe(headers)
    sleep rand(0.9)
    XRuntime::Utils.probe(headers)
    headers.inspect
  end

  get /.*/ do
    XRuntime.p.log("/index") do
      sleep(0.01*rand(10))
      "Hello, I'am x_runtime"
    end
  end
end

# Use with basic auth
run Rack::URLMap.new \
  "/"       => Server.new,
  "/xruntime" => XRuntime::Server.new