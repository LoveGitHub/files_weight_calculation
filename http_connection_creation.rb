require "net/http"

module HttpConnection
  def login_to_host(resources = nil)
    create_persistent_connections(resources)
  end

  def create_persistent_connections(resources = nil)
    uri = URI(@base_url)
    # creating the secure HTTP connection.
    Net::HTTP.start(uri.host, uri.port,:use_ssl => true) do |http|
      # trying to login to the target host with the user provided credentials.
      response = http.post URI(make_url("user_sessions.json")).path,  URI.encode_www_form(@param)
      if response.code == '201'
        puts "User logged in successfully" 
      else
        raise "Invalid credentials"
      end
      resources.each { |resource| send(resource,http,collect_cookies(response)) }
    end
  end

  def make_url(apipath)
    @base_url + "/api/open-v1.0/" + apipath
  end

  def collect_cookies(response)
    # collecting only the cookies provided by host to access the other resources from the target host
    cookies = response.get_fields('set-cookie').map { |cookie| cookie.split('; ')[0] }
    #combining the cookies and returned
    cookie_hash = { 'Cookie' => cookies.join('; ') }
  end

  private :make_url, :login_to_host, :create_persistent_connections
end



