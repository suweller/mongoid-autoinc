class User
  include Mongoid::Document
  include Mongoid::Autoinc

  field :name
  field :number

  has_many :operations

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

class Operation
  include Mongoid::Document
  include Mongoid::Autoinc

  field :name
  field :op_number

  belongs_to :user

  increments :op_number, :scope => lambda { user.name }

end

class Intern
  include Mongoid::Document
  include Mongoid::Autoinc

  field :name
  field :number

  increments :number, :auto => false

end

class Vehicle
  include Mongoid::Document
  include Mongoid::Autoinc

  field :model
  field :vin

  increments :vin, seed: 1000

end
