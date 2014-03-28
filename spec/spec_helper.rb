ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require 'sinatra/base'
require_relative "../app"
require_relative '../client'

include Rack::Test::Methods

def app
  MyApp
end

module HtmlParsing
  require 'nokogiri'
  def get_title_of_a_page(doc_string)
    Nokogiri::HTML(doc_string).title
  end
end

include HtmlParsing 
