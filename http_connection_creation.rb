require "net/http"

module HttpConnection
  def login_to_host(resources)
      create_persistent_connections(resources)
  end

  def create_persistent_connections(resources)
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
      # collecting all the cookies provided by host to access the other resources from the target host
      cookies = response.get_fields('set-cookie').map do |cookie|
        cookie.split('; ')[0]
      end
      cookie_hash = { 'Cookie' => cookies.join('; ') }
      resources.each { |resource| send(resource,http,cookie_hash) }
    end
  end

  def get_files(http_connection,cookie_hash)
    # trying to connect the resource through which we can access the users files hosted in the
    # target servers
    response = http_connection.get URI(make_url('files.json')).path, cookie_hash
    if response.code == '200'
      puts "able to extract the list of files successfully"
      @josn_files = response.body # gives the file list as a JSON hash
    else
      puts "couldn't fetch the file lists from host, so try again"
    end
  end

  def resource_lists_to_access(*resources)
    resource_hash = { 1 => :get_files }
    # trying to log in using the users specified credentials. If log in is not possible, a message will be displayed
    # to a page.
    raise 'Invalid resource access' unless resource_hash.keys.all? { |resource| resources.include? resource }
    login_to_host(resource_hash.values_at(*resources))
  end

  def make_url(apipath)
    @base_url + "/api/open-v1.0/" + apipath
  end

  private :make_url, :login_to_host, :create_persistent_connections, :get_files
end



