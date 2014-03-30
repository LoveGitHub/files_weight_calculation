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

  # target API gives the file related all informations for a specific user as a JSON. Now this method will parse the JSON
  # to convert it to a valid Hash object. Then from the Hash, we will extract information, that we need.
  def parse_json(json)
    require 'json'
    JSON.parse(json)["files"].map { |h| h.values_at('size', 'name', 'extension') }
  end

  def weight_of_files_of_a_user
    begin
      # any of the user specific action will be having a specfic resource handler, and those handlers also has a specific
      # id asscocited with them. Thus we are passing 1 which is the id of resource handler 'get files'.
      resource_lists_to_access(1)
      files_after_classification = file_classification parse_json(@josn_files ) 
      final_report_data_as_a_hash = final_report_data_as_a_hash(files_after_classification)
      # this is the array, we will be passing to the report.erb view to iterate through and create the HTML table report.
      [ 
        total_gravity_calculation(final_report_data_as_a_hash),
        added_gravity_calculation(final_report_data_as_a_hash),
        final_report_data_as_a_hash
      ]
    # If any excpetion is raised, then a blank/empty array will be returned to the `/report` page, which in turn will
    # navigate to the `/error` page to show the user a specific message.
    rescue RuntimeError => ex
      case ex.message
      when 'No handlers found for the requested action' then []
      when "Invalid credentials" then []
      end
    end
  end

  # As a user can upload any type of files in his/her workshare account. And API will give only those files names,size, 
  # extensions etc. Now the below method will group them by their extension to categorize them in a known set of document
  # type list.
  def file_classification(parsed_json)
    parsed_json.map do |a|
      a[-1] = @@category_of_files.find { |k,v| v.include?(a.last) }.first ; a
    end
  end

  # this method will calculate gravity of each type of document depending on the each type of document's size. Then it
  # will sum those to yield the total gravity added to the total size of all documents any specfic user stored in his/her
  # workshare account.( actual size weight of files are exculded in this calculation )
  def added_gravity_calculation(hash_of_document_type_wise)
    hash_of_document_type_wise.map do |document_type,(number_of_documents, _)|
      number_of_documents * @@gravities_of_files[document_type]
    end.inject(:+).round(2)
  end

  # this will give you total gravity of all document types, calculation included also the files size.
  def total_gravity_calculation(hash_of_document_type_wise)
    hash_of_document_type_wise.map { |_, (_, gravity_per_doc)| gravity_per_doc }.inject(:+)
  end

  # this method will create the hash which in turn will hold the data of our final html report, that we planned to show
  # in the report page.
  def final_report_data_as_a_hash(classified_documents)
    Hash[classified_documents.group_by { |a| a.last }.map do |document_type,document_information|
     [
        document_type, 
        [  
          document_information.size, calculate_gravity_of_each_document(document_information,document_type)
        ]
      ]
    end]
  end

  # same as added_gravity_calculation, but it included the size and wieght in the calculation.
  def calculate_gravity_of_each_document(document_information,document_type)
    ((document_information.map(&:first).inject(:+) * @@gravities_of_files[document_type])/1000).round(2)
  end
end
