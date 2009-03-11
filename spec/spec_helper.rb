require 'rubygems'
require 'sinatra/test/bacon'

$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'nancy'
require 'methods'
require 'dm-core'
require 'nokogiri'

# get a summary of errors raised and such
Bacon.summary_on_exit

class Bacon::Context
  include Sinatra::Nancy::Test::Methods
  include Sinatra::Nancy
end

def log(message)
  $stdout.puts message.inspect
end




