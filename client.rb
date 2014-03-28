require_relative './http_connection_creation.rb'

module FileReport
  @@category_of_files = { 
    'Videos' => ['avi', 'wmv', 'vob', 'swf', 'rm', 'mpg', 'mov', 'mp4'],
    'Songs' => ['mp3', 'wma', 'wav', 'au'],
    'Text' => ['txt'],
    'Binary' => ['bin'],
    'Documents' => ['pdf', 'ppt', 'docx', 'doc', 'odt', 'rtf']
  }
  @@gravities_of_files = {'Documents'=>1.1, 'Videos'=>1.4, 'Songs'=>1.2, 'Text'=>100}
  # setting the default value, to take the gravity as 1 for file types that are not listed
  # @gravities_of_files.
  @@gravities_of_files.default = 1 
  def parse_json(json)
    require 'json'
    JSON.parse(json)["files"].map { |h| h.values_at('size', 'name', 'extension') }
  end
  def weight_of_files_of_a_user
    begin
      resource_lists_to_access(1)
            files_after_classification = parse_json(@josn_files ).map do |a|
        a.fill(@@category_of_files.find { |k,v| v.include?(a.last) }.first,-1,1)
      end
      final_report_data_as_a_hash = Hash[files_after_classification.group_by { |a| a.last }.map do |documen_type,document_information|
        gravity_of_document = (document_information.map(&:first).inject(:+) * @@gravities_of_files[documen_type])/1000
        [documen_type, [document_information.size,gravity_of_document.round(2)]]
      end]
      total_gravity = []
      added_gravity = final_report_data_as_a_hash.map do |document_type,(number_of_documents,gravity_per_doc)|
        total_gravity << gravity_per_doc
        number_of_documents * @@gravities_of_files[document_type]
      end.inject(:+).round(2)
      [total_gravity.inject(:+),added_gravity,final_report_data_as_a_hash]
    rescue RuntimeError => ex
      case ex.message
      when 'Invalid resource access' then []
      when "Invalid credentials" then []
      end
    end
  end
end

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
