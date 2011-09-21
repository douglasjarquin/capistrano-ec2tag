# capistrano-ec2tag

A Capistrano plugin aimed at easing the pain of deploying to Amazon EC2
instances.

## Introduction

capistrano-ec2tag is a [Capistrano](https://github.com/capistrano/capistrano) plugin designed to simplify the
task of deploying to infrastructure hosted on [Amazon EC2](http://aws.amazon.com/ec2/). It was
completely inspired by the [capistrano-ec2group](https://github.com/logandk/capistrano-ec2group) plugin, to which all credit is due.

While the original [capistrano-ec2group](https://github.com/logandk/capistrano-ec2group) plugin served me well, I started to run into limitations pretty quickly. I will say that at the time that the capistrano-ec2group plugin was written, I don't think Amazon EC2 supported tags.

## Installation

### Set the Amazon AWS Credentials

In order for the plugin to list out hostnames of your EC2 instances, it
will need access to the Amazon EC2 API. Specify the following in your
Capistrano configuration:

```ruby
set :aws_access_key_id, '...'
set :aws_secret_access_key, '...'
```

**Suggestion**

My prefferred method of passing Amazon AWS credentials to the different
tools is to use environment variables. A trick I picked up from the [Chef
help site](http://help.opscode.com/discussions/questions/246-best-practices-for-multiple-developers-kniferb-in-chef-repo-or-not).

In my ~/.zshrc I have:

```zsh
# Set the Amazon AWS credentials as environment variables
export AWS_ACCESS_KEY_ID='...'
export AWS_SECRET_ACCESS_KEY='...'
```

Then, in my ~/.caprc I do the following:

```ruby
set :aws_access_key_id, $AWS_ACCESS_KEY_ID
set :aws_secret_access_key, $AWS_SECRET_ACCESS_KEY
```

### Get the gem

The plugin is distributed as a Ruby gem.

**Ruby Gems**

```bash
gem install capistrano-ec2tag
```

**Bundler**

Using [bundler](http://gembundler.com/)?

```bash
gem install bundler
```

Then add the following to your Gemfile:

```ruby
source "http://rubygems.org"
gem "capistrano-ec2tag"
```

Install the gems in your manifest using:

```bash
bundle install
```

#### Usage:

```ruby
require 'capistrano/ec2tag'

task :deploy do
  tag "testing-web", :web
  logger.info "Deploying to the TESTING environment!"
end
```

# License

capistrano-ec2tag is copyright 2011 by [Douglas Jarquin](http://www.douglasjarquin.com/), released under the MIT License (see LICENSE for details).

