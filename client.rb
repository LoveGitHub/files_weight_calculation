require_relative './http_connection_creation'
require_relative './file_report'

  class Client
    include FileReport
    include HttpConnection
    BASE_URL = "https://my.workshare.com"
    def initialize(api_id, usrnm, passwd, url = BASE_URL)
      @base_url = url
      @api_id = api_id
      @param = { 
        'user_session[email]' => usrnm, 
        'user_session[password]' => passwd,
        'device[app_uid]' => @api_id
      }
    end
  end
