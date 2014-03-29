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
      files_after_classification = file_classification parse_json(@josn_files ) 
      final_report_data_as_a_hash = final_report_data_as_a_hash(files_after_classification)
      total_gravity = total_gravity_calculation(final_report_data_as_a_hash)
      added_gravity = added_gravity_calculation(final_report_data_as_a_hash)
      [total_gravity,added_gravity,final_report_data_as_a_hash]
    rescue RuntimeError => ex
      case ex.message
      when 'Invalid resource access' then []
      when "Invalid credentials" then []
      end
    end
  end

  def file_classification(parsed_json)
    parsed_json.map do |a|
      a.fill(@@category_of_files.find { |k,v| v.include?(a.last) }.first,-1,1)
    end
  end

  def added_gravity_calculation(hash_of_document_type_wise)
    hash_of_document_type_wise.map do |document_type,(number_of_documents, _)|
      number_of_documents * @@gravities_of_files[document_type]
    end.inject(:+).round(2)
  end

  def total_gravity_calculation(hash_of_document_type_wise)
    hash_of_document_type_wise.map { |_, (_, gravity_per_doc)| gravity_per_doc }.inject(:+)
  end

  def final_report_data_as_a_hash(classified_documents)
    Hash[classified_documents.group_by { |a| a.last }.map do |documen_type,document_information|
      gravity_of_document = (document_information.map(&:first).inject(:+) * @@gravities_of_files[documen_type])/1000
      [documen_type, [document_information.size,gravity_of_document.round(2)]]
    end]
  end
end
