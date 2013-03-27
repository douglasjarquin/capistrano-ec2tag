## Introduction

capistrano-ec2tag is a [Capistrano](https://github.com/capistrano/capistrano) plugin designed to simplify the
task of deploying to infrastructure hosted on [Amazon EC2](http://aws.amazon.com/ec2/). It was
completely inspired by the [capistrano-ec2group](https://github.com/logandk/capistrano-ec2group) plugin, to which all credit is due.

While the original [capistrano-ec2group](https://github.com/logandk/capistrano-ec2group) plugin served me well, I started to run into limitations pretty quickly. I will say that at the time that the capistrano-ec2group plugin was written, I don't think Amazon EC2 supported tags yet.

Using Tags instead of Security Groups gives you the ability to change which servers get deployed to at any time, without having to reboot the instance. This implementation is particularly useful for A/B deployments, or in auto-scaling environments.

## Installation

### Set the Amazon AWS Credentials

In order for the plugin to list out the hostnames of your EC2 instances, it
will need access to the Amazon EC2 API. Specify the following in your
Capistrano configuration:

```ruby
set :aws_access_key_id, '...'
set :aws_secret_access_key, '...'
```

**Suggestion**

My preferred method of passing Amazon AWS credentials to the different tools is to use environment variables. A trick I picked up from the [Chef help site](http://help.opscode.com/discussions/questions/246-best-practices-for-multiple-developers-kniferb-in-chef-repo-or-not).

In my `~/.zshrc` I have:


```zsh
# aws credentials
export AWS_ACCESS_KEY_ID='...'
export AWS_SECRET_ACCESS_KEY='...'
```

Then, in a `~/.caprc` I do the following:

``` ruby
set :aws_access_key_id, ENV['AWS_ACCESS_KEY_ID']
set :aws_secret_access_key, ENV['AWS_SECRET_ACCESS_KEY']
```

### Get the gem

The plugin is distributed as a Ruby gem.

**Ruby Gems**

```bash
gem install capistrano-ec2tag
```

**Bundler**

Using [bundler](http://gembundler.com/)?

``` ruby
source 'http://rubygems.org'
gem 'capistrano-ec2tag'
```

Install the gems in your manifest using:

``` bash
bundle install
```

## Usage

### Tag your instances

Using the Amazon EC2 API or the AWS Management Console, add a `deploy` tag to all the instances you want Capistrano to deploy to.

The value can be any string, but I do recommend it be both unique and easy to recognize. If you have used the [capistrano-ec2group](https://github.com/logandk/capistrano-ec2group), then this might be equal to whatever security group names you use.

Personally, we use the folowing convention:

```
APP-ENVIRONMENT
```

### Configure Capistrano

```ruby
require 'capistrano/ec2tag'

task :production do
  tag 'github-production', :web
  logger.info 'Deploying to the PRODUCTION environment!'
end

task :staging do
  tag 'github-staging', :web
  logger.info 'Deploying to the STAGING environment!'
end
```

## License

capistrano-ec2tag is copyright 2013 by [Douglas Jarquin](http://douglasjarquin.com/), released under the MIT License (see LICENSE for details).
