require_relative './client.rb'

class MyApp < Sinatra::Base

  class MyCustomError < StandardError; end
  configure :development do
    disable :raise_errors
    disable :show_exceptions
    #set :dump_errors, false
  end
  get '/' do
    send_file 'public/page.html'
  end

  post '/report/?' do
    client = Client.new(params[:Secureid], params[:email], params[:passwort])
    @total_gravity, @added_gravity, @table_rows = *client.weight_of_files_of_a_user
    if [@total_gravity, @added_gravity, @table_rows].all?(&:nil?)
      raise MyCustomError, "Combination of email id, password and application id is not valid, please try again with a valid one."
    end
    erb :report, :locals => {:title => 'Report of files'}
  end

  error MyCustomError do
    erb :error, :locals => {:title => 'Error Page', :message =>  env['sinatra.error'].message }
  end
end

