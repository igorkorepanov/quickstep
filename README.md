[![Gem Version](https://badge.fury.io/rb/quickstep.svg)](https://badge.fury.io/rb/quickstep)
![CI](https://github.com/igorkorepanov/quickstep/actions/workflows/main.yml/badge.svg)

# Quickstep

Quickstep is a lightweight business operation tool inspired by [dry-operation](https://github.com/dry-rb/dry-operation). It provides a structured way to execute multi-step operations with built-in success and failure handling.

## Installation

Add this line to your application's Gemfile:

```ruby
 gem 'quickstep', '1.0.0'
```

Or install it manually:

```sh
 gem install quickstep
```

## Usage

### Defining an Operation

Operations in Quickstep are composed of sequential steps. Each step returns either a `Success` or a `Failure`. If any step fails, the operation halts immediately.

```ruby
require 'quickstep'

class MyOperation
  include Quickstep

  def call(input)
    step validate(input)
    step process(input)
  end

  private

  def validate(input)
    input[:valid] ? Success(input) : Failure(:invalid_input)
  end

  def process(input)
    Success(result: input[:value] * 2)
  end
end

result = MyOperation.new.call(valid: true, value: 5)

if result.success?
  puts "Success: #{result.value}"
else
  puts "Failure: #{result.value}"
end
```

### Chaining Operations

In Quickstep, you can use the result of another operation as a step in your operation.  
This allows you to compose operations naturally and reuse existing logic.

```ruby
class MainOperation
  include Quickstep

  def call
    step step1
    step SecondOperation.new.call # chaining another operation
  end

  private

  def first_step
    Success("first step")
  end
end

class SecondOperation
  include Quickstep

  def call
    step first_step
    step second_step
  end

  private

  def first_step
    Success("Step from SecondOperation")
  end
end
```

### Notes
- Any value returned by `call` that is not already a `Success` or `Failure` will be wrapped in a `Success` automatically.
- Operations can be executed either via an **instance** or directly on the **class**:
```ruby
# Using an instance
result = MyOperation.new.call(:input)

# Using the class method shortcut
result = MyOperation.call(:input)
```


## License

Quickstep is available under the MIT License.

