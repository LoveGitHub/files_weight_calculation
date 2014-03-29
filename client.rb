require_relative './file_report'
require_relative './resource_handlers'

class Client
  include FileReport
  include ResourceHandler
  BASE_URL = "https://my.workshare.com"
  @actions = {'1' => :weight_of_files_of_a_user}

  def initialize(api_id, usrnm, passwd, url = BASE_URL)
    @base_url = url
    @api_id = api_id
    @param = { 
      'user_session[email]' => usrnm, 
      'user_session[password]' => passwd,
      'device[app_uid]' => @api_id
    }
  end

  # this method will give access to the variable which knows the id of each users requested actions
  def self.actions_allowed
    @actions
  end

  # this method will give the actual method name, which needed to complete the user task.
  def action_want_to_perform(arg)
    self.class.actions_allowed[arg]
  end
end
