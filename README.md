# lita-alias

[![Build Status](https://travis-ci.org/apsoto/lita-alias.png?branch=master)](https://travis-ci.org/apsoto/lita-alias)
[![Coverage Status](https://coveralls.io/repos/apsoto/lita-alias/badge.png)](https://coveralls.io/r/apsoto/lita-alias)

If you utilize some plugins that have long complicated commands because they accept arguments and you would like to alias into shorter commands, this plugin can help you.

For example, if you have a command to run a process on a heroku app to check stats that you like to run periodically:

    /hk run my-company-production ./bin/check_stats

That's a bit verbose, so you could alias as `stats_prod` by doing the following:
   
    /alias add stats_prod hk run my-company-production ./bin/check_stats

Then you simply have to type:

    /stats_prod

See [Usage](#usage) for more details.

## Installation

Add lita-alias to your Lita instance's Gemfile:

``` ruby
gem "lita-alias"
```

## Requirements
The plugin requires access to redis for storing aliases

## Configuration

none yet

## Usage

### add

    /alias add ALIAS COMMAND

Adds an alias so when you type the command `/ALIAS` the COMMAND is sent instead as if you had typed it yourself.  Do not put the robot alias character ('/' for example) in the COMMAND argument.  When the ALIAS is triggered, the chatbot will receive the COMMAND as a chat message with your robot's alias character prepended.

Example: `/alias add stats_prod hk run my-company-production ./bin/refresh_cache`

### delete

    /alias delete ALIAS

Deletes the ALIAS.

Example: `/alias delete stats_prod`

### list

    /alias list

Shows all the aliases that have been saved.

## Notes
Some COMMANDS maybe triggered when you alias them if the handler's route is very loose with where it may appear in a chat message.