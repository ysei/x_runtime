module XRuntime
  class Server
    def initialize(app=nil, &auth)
      @server = lambda {|env|
        @req = Rack::Request.new(env)
        [200, {'Content-Type' => 'text/html'}, [Template.new(XRuntime.middleware.ds, :limit => (@req.params["limit"] ? @req.params["limit"].to_i : 20), :offset => @req.params["offset"].to_i).render]]
      }
      @server = Rack::Auth::Basic.new(@server, &auth) if auth
    end
        
    def call(env)
      @server.call(env)
    end
  end
end