require_relative './http_connection_creation'

module ResourceHandler
  include HttpConnection

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

  def resource_lists_to_access(action_handler)
    resource_hash = { 1 => :get_files }
    # trying to log in using the users specified credentials. If log in is not possible, a message will be displayed
    # to a page.
    raise 'No handlers found for the requested action' unless resource_hash.keys.include? action_handler
    login_to_host(resource_hash[action_handler])
  end
end
