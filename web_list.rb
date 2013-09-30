require 'twitter'
require 'rack'
require 'erb'
require 'pry-debugger'
require 'thin'
require './configure'

class WebList
  def initialize
    @all_tweets = [] # Array where all tweets will be saved
    @name = ''       # Username
    @number = 0      # Number of tweets to show
  end

  def erb(template)
    template_file = File.open("web_list.html.erb", 'r')
    ERB.new(File.read(template_file)).result(binding)
  end

  def call env
    req = Rack::Request.new(env)
    
    binding.pry if ARGV[0]

    @name = (req["firstname"] && req["firstname"] != '' && Twitter.user?(req["firstname"]) == true ) ? req["firstname"] : ''

    @number = (req["n"] && req["n"].to_i>1 ) ? req["n"].to_i : 1

    if @name == req["firstname"]
      ultimos_t = Twitter.user_timeline(@name,{:count=>@number.to_i})
      @todo_tweet =(@todo_tweet && @todo_tweet != '') ? ultimos_t.map{ |i| i.text} : ''       
    end

    Rack::Response.new(erb('twitter.html.erb'))
  end
end

Rack::Server.start(
  :app => WebList.new,
  :Port => 9292,
  :server => 'thin'
)