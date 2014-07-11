class AutoincDocument
  include Mongoid::Document
  include Mongoid::Autoinc
end

class User < AutoincDocument
  field :name
  field :number
  has_many :operations
  increments :number
end
SpecialUser = Class.new(User)

class PatientFile < AutoincDocument
  field :name
  field :file_number
  increments :file_number, scope: :name
end

class Operation < AutoincDocument
  field :name
  field :op_number
  belongs_to :user
  increments :op_number, scope: -> { user.name }
end

class Intern < AutoincDocument
  field :name
  field :number
  increments :number, auto: false
end

class Vehicle < AutoincDocument
  field :model
  field :vin
  increments :vin, seed: 1000
end

class Ticket < AutoincDocument
  field :number
  increments :number, step: 2
end

class LotteryTicket < AutoincDocument
  field :start, type: Integer, default: 0
  field :number
  increments :number, step: -> { start + 1 }
end

class Stethoscope < AutoincDocument
  field :number
  increments :number, model_name: :stetho
end
