# Kira

[![wemake.services](https://img.shields.io/badge/%20-wemake.services-green.svg?label=%20&logo=data%3Aimage%2Fpng%3Bbase64%2CiVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAABGdBTUEAALGPC%2FxhBQAAAAFzUkdCAK7OHOkAAAAbUExURQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP%2F%2F%2F5TvxDIAAAAIdFJOUwAjRA8xXANAL%2Bv0SAAAADNJREFUGNNjYCAIOJjRBdBFWMkVQeGzcHAwksJnAPPZGOGAASzPzAEHEGVsLExQwE7YswCb7AFZSF3bbAAAAABJRU5ErkJggg%3D%3D)](https://wemake.services)
[![kira-family](https://img.shields.io/badge/kira-family-pink.svg)](https://github.com/wemake-services/kira)
[![Build Status](https://travis-ci.org/wemake-services/kira.svg?branch=master)](https://travis-ci.org/wemake-services/kira)
[![Coverage Status](https://coveralls.io/repos/github/wemake-services/kira/badge.svg?branch=master)](https://coveralls.io/github/wemake-services/kira?branch=master)

Issue management framework with [deep philosophy](https://wemake.services/meta/) underneath.
Part of the [`@kira`](https://github.com/wemake-services/kira) bots family.


## Status

We have released first public bots!

### Kira's family

These bots are developed and maintained by [wemake.services](https://wemake.services):

- [kira](https://github.com/wemake-services/kira) - issue management framework with deep philosophy underneath
- [kira-setup](https://github.com/wemake-services/kira-setup) - micro-bot (CLI) to setup new GitLab projects with `RSDP` and Kira in mind
- [kira-stale](https://github.com/wemake-services/kira-stale) - micro-bot to fight with stale GitLab issues and merge requests
- [kira-review](https://github.com/wemake-services/kira-review) - micro-bot to review merge requests before real humans
- [kira-release](https://github.com/wemake-services/kira-release) - micro-bot to release your code and track changes
- [kira-dependencies](https://github.com/wemake-services/kira-dependencies) - micro-bot to continuously update your dependency versions, based on dependabot
- kira-wakatime - WIP: micro-bot to track time you spend writing code
- kira-branches - WIP: micro-bot to delete stale branches
- kira-reviewers - WIP: micro-bot to assign reviewers based on codeownership
- kira-stats - WIP: micro-bot to visualize your project's stats
- kira-security - WIP: micro-bot to security audit your apps

### Kira's friends

These bots are developed and maintained by other awesome people:

- [marge-bot](https://github.com/smarkets/marge-bot) - a merge-bot for GitLab
- [dependabot](https://github.com/dependabot/dependabot-script) - dependencies upgrade bot
- [zeit](https://zeit.co/docs/v2/integrations/now-for-gitlab) - deploy each pull request to Now

## Development

To start your Phoenix server:

  * Make sure to set all `env` variables from `.env.template`
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
