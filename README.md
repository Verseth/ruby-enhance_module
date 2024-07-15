# EnhanceModule

This gem adds a typed, sorbet-friendly way of extending object instances with modules.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add enhance_module

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install enhance_module


## Motivation

Ruby supports extending objects with methods from modules.
It's one of the most unique and cool features of Ruby.

```rb
module Foo
    def foo = "foo!"
end

obj = Object.new
obj.extend(Foo)
obj.foo #=> foo!
```

Unfortunately [sorbet](https://sorbet.org/) does not support this feature.
Its type system in unable to fathom what is going on when an object is extended.

```rb
# typed: true

module Foo
    extend T::Sig

    sig { void }
    def foo = "foo!"
end

obj = Object.new
obj.extend(Foo)
obj.foo #! Method `foo` does not exist on `Object`
```

## Usage

This gem adds a new sorbet-friendly way of extending objects.

```rb
# typed: true

require 'enhance_module'

module Foo
    extend T::Sig

    # boilerplate that needs to be added
    # to your module to make it support
    # extending objects
    class << self
        include EnhanceModule
        has_attached_class! { { fixed: Foo } }
    end

    # define your methods
    sig { void }
    def foo = "foo!"
end

obj = Object.new
# works the same as `obj.extend(Foo)`
# but sorbet understands it
extended_obj = Foo.enhance(obj)
extended_obj.foo # ok!

T.reveal_type(extended_obj) # T.all(Foo, Object)
```

The new `Foo.enhance` method works like `extend` and
returns an intersection type that consists of the argument's class
and the module that is being extended.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Verseth/enhance_module.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
