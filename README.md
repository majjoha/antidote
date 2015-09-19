# Antidote
[![Gem Version](https://badge.fury.io/rb/antidote-types.svg)](http://badge.fury.io/rb/antidote-types)
[![Build Status](https://travis-ci.org/majjoha/antidote.svg)](https://travis-ci.org/majjoha/antidote)
[![Coverage Status](https://coveralls.io/repos/majjoha/antidote/badge.svg?branch=master&service=github)](https://coveralls.io/github/majjoha/antidote?branch=master)

Antidote is a small, highly experimental library that performs runtime type
assertions in Ruby in the same vein as
[Rubype](https://github.com/gogotanaka/Rubype),
[contracts.ruby](https://github.com/egonSchiele/contracts.ruby),
[sig](https://github.com/janlelis/sig), and so on. This repository should mainly
be considered a proof of concept.

It relies heavily on metaprogramming, and it is unsafe for method calls with
side-effects. Nonetheless, it works.

Antidote exposes two methods: `annotate`, and `annotate_class_method` which can
be used a such:

```ruby
require_relative 'lib/antidote'

class Adder
  include Antidote

  annotate Fixnum, Fixnum, Fixnum do
  def add(x, y)
    x + y
  end
  end
end

adder = Adder.new.add(1, 2)
```

Here, `annotate Fixnum, Fixnum, Fixnum` means that we expect two `Fixnum` as
input, and we should return a `Fixnum` as result.

This program returns 3 as expected since we comply with the type signature, but
if we change `x` to be a `String`, we receive the following error message:

```
Variable `x` in method `add` expected a String, but received a Fixnum
(Antidote::VariableTypeError)
```

If we change the return type, we'll see a similar message:

```
Expected `add` to return a String, but it returned a Fixnum instead
(Antidote::ReturnTypeError)
```

You can obviously handle both `Antidote::VariableTypeError` and
`Antidote::ReturnTypeError` in your code if needed.

Please, visit [`example.rb`](example.rb) for a full example.

## Requirements
* Ruby 2.2.0 or newer.

## Installation
Add this line to your Gemfile:

```ruby
gem 'antidote-types'
```

And then run:

```
bundle
```

Or simply install it yourself:

```
gem install antidote-types
```

## Contribute
1. [Fork it](https://github.com/majjoha/antidote/fork).
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Commit your changes (`git commit -am 'Add some new feature.'`).
4. Push to the branch (`git push origin my-new-feature`).
5. Create a new pull request.

## License
See [LICENSE](https://github.com/majjoha/antidote/blob/master/LICENSE).
Copyright (c) 2014 Mathias Jean Johansen <<mathias@mjj.io>>
