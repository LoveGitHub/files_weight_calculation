require_relative 'spec_helper'

describe 'File weight calaculation app' do

  describe 'Home page' do
    it 'should have title as Home Page' do
      # get method is being called by the class Rack::Test::Methods
      # after get method call, it gives us Rack::MockResponse class instance
      get '/'
      last_response.must_be :ok?
      get_title_of_a_page(last_response.body).must_equal 'Home Page'
    end

    describe 'When the log in credentials are correct' do
      it 'should help that specific user to log in' do
        post '/report', {:Secureid => 'c664cbdc-6b11', :email => 'aruprakshit@rocketmail.com', :passwort => 'arupws1987'}
        get_title_of_a_page(last_response.body).must_equal 'Report of files'
      end
    end

    describe 'When the log in credentials are not correct' do
      it 'will prevent the user to log in' do
        post '/report', {:Secureid => 'c664cbdc-6b211', :email => 'aruprakshit@rocketmail.com', :passwort => 'arupws1987'}
        get_title_of_a_page(last_response.body).must_equal 'Error Page'
      end
    end
  end
end
