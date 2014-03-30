require_relative './http_connection_creation'

module ResourceHandler
  include HttpConnection

  def get_files(http_connection,cookie_hash)
    # trying to connect the resource through which we can access the users files hosted in the
    # target servers
    response = http_connection.get URI(make_url('files.json')).path, cookie_hash
    if response.code == '200'
      # able to extract the list of files successfully.
      @josn_files = response.body # gives the file list as a JSON hash
    else
      # if the cookie expired or or http connection is lost or API url to access the file is changed, then error will
      # be thrown.
      puts "couldn't fetch the file lists from host, so try again"
    end
  end

  # this method knows, what's the id of each specific resource handlers and will log in to the host and then call the
  # specific handler.
  def resource_lists_to_access(action_handler)
    resource_hash = { 1 => :get_files }
    # trying to log in using the users specified credentials. If log in is not possible, a message will be displayed
    # to a page.
    raise 'No handlers found for the requested action' unless resource_hash.keys.include? action_handler
    login_to_host(resource_hash[action_handler])
  end
end
