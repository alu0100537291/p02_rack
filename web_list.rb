require 'faraday'
require 'twitter'
require 'rack'
require 'pry-debugger'
require 'thin'

class HelloWorld

  def call env
    req = Rack::Request.new(env)
    res = Rack::Response.new 
    binding.pry if ARGV[0]
    res['Content-Type'] = 'text/html'
    name = (req["firstname"] && req["firstname"] != '') ? req["firstname"] :'World'
    res.write <<-"EOS"
      <!DOCTYPE HTML>
      <html>
        <title>Rack::Response</title>
        <body>
          <h1>
             Hello #{name}!
             <form action="/" method="post">
               Your name: <input type="text" name="firstname" autofocus><br>
               <input type="submit" value="Submit">
             </form>
          </h1>
        </body>
      </html>
    EOS
    res.finish
  end
end

Rack::Server.start(
  :app => HelloWorld.new,
  :Port => 9292,
  :server => 'thin'
)