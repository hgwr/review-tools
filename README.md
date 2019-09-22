[![Build Status](https://travis-ci.org/hgwr/review-tools.svg?branch=master)](https://travis-ci.org/hgwr/review-tools)

[![Gem Version](https://badge.fury.io/rb/review-tools.svg)](https://badge.fury.io/rb/review-tools)

# Review::Tools

This is a tool that automates the review of pull requests for Rails project on GitHub.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'review-tools', require: false, group: :development
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install review-tools

## Usage

1. See the pull request page on GitHub. You will see like these lines.

> ### add some cool features #2
>
> **Open**	hgwr wants to merge 4 commits into master from dev

2. Copy `into master from dev` and paste like `run_review.sh into master from dev` to terminal.

3. Then, `run_review.sh into master from dev` executes these operaitons.

- `git checkout ...`
- Preparing environments. (e.g. Database migrations)
- Run tests
- If you are using simplecov, you can see coverages of modified files.

## Customization

You can put custom shell scripts in `~/.config/review-tools.yml`.

For example:

```
additional_preparation: |
  rm -rf node_modules && yarn

additional_db_preparation: |
  bundle exec bin/rails db:some:your:task

additional_test_tasks: |
  eslint app/assets/javascripts/**/*
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hgwr/review-tools. 
This project is intended to be a safe, welcoming space for collaboration, 
and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Review::Tools project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hgwr/review-tools/blob/master/CODE_OF_CONDUCT.md).
