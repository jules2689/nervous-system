# Nervous::System

> This system is a work in progress.

The Nervous System is a tool for connecting information sources to a centralized notes location (aka the Brain).

Its primary goal is to allow information sources to be added and removed dynamically, and to provide a unified interface for accessing information.

Right now this only integrates into Notion but is set up to allow easy integration with other platforms in the future.

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
jobs = [
    Nervous::System::ETL::Jobs::TodoistSyncJob.setup(backend: :notion, env: ENV),
    Nervous::System::ETL::Jobs::GeekbotSyncJob.setup(backend: :notion, env: ENV),
]
jobs.each [ |j| Kiba.run(j) }
```

3. Add a `Rakefile` and add:
```ruby
# frozen_string_literal: true
require "nervous/system/tasks"
```

4. Setup databases in Notion for the chosen integrations. See [Database Properties](#database-properties) for instructions

5. Add Tokens and other environments variables to a `.env` file, or to your environment
- Make sure to gitignore the `.env` file.
- You should provide the tokens specified below under the [Tokens and Env Vars](#tokens-and-env-vars) section

6. Add a `db/config.yml` file with the following content:
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

7. Run `bundle install`

8. Run `bundle exec rake db:create db:migrate`

9. Run `bundle exec run.rb`


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jules2689/nervous-system. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/jules2689/nervous-system/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Nervous::System project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jules2689/nervous-system/blob/main/CODE_OF_CONDUCT.md).

## Tokens and Env Vars

| Name | What is it? | How do I get it? |
| --- | --- | --- |
| **Notion** | | |
| `NOTION_TOKEN` | An access token for your Notion Integration, the official API | https://developers.notion.com/ |
| `NOTION_UNOFFICIAL_TOKEN` | An access token for the unofficial Notion API. Used to fill in gaps from the official API | See below |
| `NOTION_SPACE_ID` | The Space ID for use with the unofficial API. | See below |
| **Geekbot** | | |
| `GEEKBOT_ACCESS_TOKEN` | Access token for Geekbot, if used. | https://geekbot.com/dashboard/api-webhooks |
| `GEEKBOT_STANDUP_ID` | The Standup you wish to sync, if needed | From the URL of a standup listed on https://app.geekbot.com/dashboard/ |
| **Todoist** | | |
| `TODOIST_TOKEN` | API Token for your Todoist account, if needed | https://todoist.com/prefs/integrations |

### Notion Unofficial API

The official API is new and incomplete. It is missing things like deleting or updating existing blocks, setting page covers, and setting page icons. To fill in this gap, we use the unofficial API. Here are instructions for setup. Instructions are from https://compile.blog/automatic-notion-backup/.

To make it easy, here’s the step-to-step guide to proceed:

1. Open Google Chrome and log in to your Notion account
1. Navigate to Settings and Members > Settings
1. Open the Chrome DevTools by pressing ctrl + shift + j (on Windows/Linus) or cmd + option + j (on macOS)
1. Now proceed with the next instructions carefully
    - Click on the Network tab
    - Enable XHR filter
    - Clear the console by clicking on the cancel icon
    - Click on the “Export all workspace content“, select your preferred Export format and click on the Export button
    - Select enqueueTask from the Name column
    - Move to the Headers tab and scroll down till you see “cookie:“
    - Copy token_v2 and note down in a text note by name NOTION_TOKEN_V2
    - Copy spaceId from Request Payload section and note down in a text note by name NOTION_SPACE_ID

![Image showing how to get the space id and token](https://user-images.githubusercontent.com/3074765/118418462-7df4cc00-b686-11eb-97de-43b56bcf3efc.png)

## Database Properties

Databases are required to be set up in Notion with specific fields of specific types. These are as follows
### Todoist

| Name | Type of Property |
| --- | --- |
| Category | Select |
| Reminder | Date |
| Status | Select with Open and Archive Options |
| external_id | number |
| project_id | number |

### Geekbot

| Name | Type of Property |
| --- | --- |
| Category | Select |
| Person | Select |
| URL | URL |
| Status | Select with Open and Archive Options |
| GeekbotId | number |

## Known Limitations

- Unofficial Notion API must be used to fill in some gaps
- Todoist content is not synced into Notion yet.
