# mongoid-autoinc

A mongoid plugin to add auto incrementing fields to your documents.

[![Inline docs](
http://inch-ci.org/github/suweller/mongoid-autoinc.svg?branch=master&style=flat
)](http://inch-ci.org/github/suweller/mongoid-autoinc)
[![Code Climate](
http://img.shields.io/codeclimate/github/suweller/mongoid-autoinc.svg?style=flat
)](https://codeclimate.com/github/suweller/mongoid-autoinc)
[![Build Status](
http://img.shields.io/travis/suweller/mongoid-autoinc.svg?style=flat
)](https://travis-ci.org/suweller/mongoid-autoinc)

## Installation

in gemfile:

``` ruby
gem 'mongoid-autoinc'
```

in class:

``` ruby
require 'autoinc'
```

## Usage

``` ruby
# app/models/user.rb
class User
  include Mongoid::Document
  include Mongoid::Autoinc
  field :name
  field :number, type: Integer

  increments :number
end

user = User.create(name: 'Dr. Percival "Perry" Ulysses Cox')
user.id # BSON::ObjectId('4d1d150d30f2246bc6000001')
user.number # 1

another_user = User.create(name: 'Bob Kelso')
another_user.number # 2
```

### Scopes

You can scope on document fields. For example:

``` ruby
class PatientFile
  include Mongoid::Document
  include Mongoid::Autoinc

  field :name
  field :number, type: Integer

  increments :number, scope: :patient_id

  belongs_to :patient

end
```

Scope can also be a Proc:

``` ruby
increments :number, scope: -> { patient.name }
```

### Custom Increment Trigger

You can trigger the assignment of an increment field manually by passing:
`auto: false` to the increment field.
This allows for more flexible assignment of your increment number:

``` ruby
class Intern
  include Mongoid::Document
  include Mongoid::Autoinc

  field :name
  field :number

  increments :number, auto: false

  after_save :assign_number_to_jd

protected

  def assign_number_to_jd
    assign!(:number) if number.blank? && name == 'J.D.'
  end

end
```

### Custom Model Name

You can override the model name used to generate the autoincrement keys. This can be useful
when working with subclasses or namespaces.

``` ruby
class Intern
  include Mongoid::Document
  include Mongoid::Autoinc

  field :name
  field :number

  increments :number, model_name => :foo
end
```

### Seeds

You can use a seed to start the incrementing field at a given value. The first
document created will start at 'seed + 1'.

``` ruby
class Vehicle
  include Mongoid::Document
  include Mongoid::Autoinc

  field :model
  field :vin

  increments :vin, seed: 1000

end

car = Vehicle.new(model: "Coupe")
car.vin # 1001
```

### Step

The step option can be used to specify the amount to increment the field every
time a new document is created. If no step is specified, it will increment by
1.

``` ruby
class Ticket
  include Mongoid::Document
  include Mongoid::Autoinc

  field :number

  increments :number, step: 5

end
```
``` ruby
first_ticket = Ticket.new
first_ticket.number # 5
second_ticket = Ticket.new
second_ticket.number # 10
```

The step option can also be a Proc:

``` ruby
increments :number, step: -> { 1 + rand(10) }
```

### Development

```
$ gem install bundler (if you don't have it)
$ bundle install
$ bundle exec spec
```

## Contributing

* Fork and create a topic branch.
* Follow the
  [80beans styleguide](https://gist.github.com/b896eb9e66fc6ab3640d).
  Basically the [rubystyleguide](https://github.com/bbatsov/ruby-style-guide/)
  with some minor changes.
* Submit a pull request

## Contributions

Thanks to Johnny Shields (@johnnyshields) for implementing proc support to scopes
And to Marcus Gartner (@mgartner) for implementing the seed functionality

Kris Martin (@krismartin) and Johnny Shields (@johnnyshields) for adding the
overwritten model name feature

## Copyright

See LICENSE for details
