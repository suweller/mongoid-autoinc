class User
  include Mongoid::Document
  include Mongoid::Autoinc

  field :name
  field :number

  auto_increment :number

end

class PatientFile
  include Mongoid::Document
  include Mongoid::Autoinc

  field :name
  field :file_number

  auto_increment :file_number

end
