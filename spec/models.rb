class User
  include Mongoid::Document
  include Mongoid::Autoinc

  field :name
  field :number

  increments :number

end

class SpecialUser < User
end

class PatientFile
  include Mongoid::Document
  include Mongoid::Autoinc

  field :name
  field :file_number

  increments :file_number, :scope => :name

end

class Intern
  include Mongoid::Document
  include Mongoid::Autoinc

  field :name
  field :number

  increments :number, :auto => false

end
