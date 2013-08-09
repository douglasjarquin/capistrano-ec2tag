## Introduction

capistrano-ec2tag is a [Capistrano](https://github.com/capistrano/capistrano) plugin designed to simplify the
task of deploying to infrastructure hosted on [Amazon EC2](http://aws.amazon.com/ec2/). It was inspired by the [capistrano-ec2group](https://github.com/logandk/capistrano-ec2group) plugin, to which all credit is due.

While the original [capistrano-ec2group](https://github.com/logandk/capistrano-ec2group) plugin served me well, I started to run into cases where I wanted more flexibility. More specifically, in order to change security groups, instances have to be restarted.

I created capistrano-ec2tag to bypass this limitation. Now, modifying the list of instances that are deployable is as easy as modifying tags.

## Installation

Add this line to your application's Gemfile:

```
gem 'capistrano-ec2tag'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install capistrano-ec2tag
```

## Configuration

Tag your instances, using `deploy` as the key. For example:

![tag-example](https://f.cloud.github.com/assets/8209/939801/af9155fc-011d-11e3-9a6a-a07b0d4e9dc6.png)

The tag value can be any string, but I suggest using something like `APP-ENVIRONMENT`.

## Usage

Add this to the top of your `deploy.rb`:

```ruby
require 'capistrano/ec2tag'
```

Then supply your AWS credentials with the environment variables (default):

```zsh
# aws
export AWS_ACCESS_KEY_ID='...'
export AWS_SECRET_ACCESS_KEY='...'
```

Or in your `deploy.rb` with capistrano variables:

```ruby
set :aws_access_key_id, '...'
set :aws_secret_access_key, '...'
```

```ruby
# old & busted
server 'web1.example.com', :web

# new hotness
tag 'github-staging', :web
```

## License

capistrano-ec2tag is copyright 2013 by [Douglas Jarquin](http://douglasjarquin.com/), released under the MIT License (see LICENSE for details).`
