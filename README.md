# Nervous::System

The Nervous System is a tool for connecting information sources to a centralized notes location (aka the Brain).

Its primary goal is to allow information sources to be added and removed dynamically, and to provide a unified interface for accessing information.

## Installation & Usage

1. Create a Gemfile and add the following Gem:

```ruby
# frozen_string_literal: true

source "https://rubygems.org"
gem 'nervous-system', git: "https://github.com/jules2689/nervous-system.git"
gem "todoist-ruby", git: "https://github.com/jules2689/todoist-ruby.git"
gem "dotenv" # Only need this if you want to run with your env vars in .env file
```

2. Create a `run.rb` file and add:

```ruby
require 'nervous/system'
job = Nervous::System::ETL::Jobs::TodoistSyncJob.setup(backend: :notion, env: ENV)
Kiba.run(job)
```

3. Add a `Rakefile` and add:
```ruby
# frozen_string_literal: true
require "nervous/system/tasks"
```

4. [Optional] Add Tokens and other environments variables to a `.env` file, or to your environment. Make sure to gitignore the `.env` file

5. Add a `db/config.yml` file with the following content:
```yml
development:
  adapter: sqlite3
  database: db/development.sqlite3
  pool: 5
  timeout: 5000

test:
  adapter: sqlite3
  database: db/test.sqlite3
  pool: 5
  timeout: 5000

production:
  adapter: sqlite3
  database: db/production.sqlite3
  pool: 5
  timeout: 5000
```

4. Run `bundle install`

5. Run `bundle exec rake db:create db:migrate`

6. Run `bundle exec run.rb`


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/nervous-system. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/nervous-system/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Nervous::System project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/nervous-system/blob/master/CODE_OF_CONDUCT.md).
