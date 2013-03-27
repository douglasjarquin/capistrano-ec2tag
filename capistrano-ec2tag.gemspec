# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'capistrano-ec2tag'
  s.version     = '0.0.4'
  s.authors     = ['Douglas Jarquin']
  s.email       = ['douglasjarquin@me.com']
  s.homepage    = 'https://github.com/douglasjarquin/capistrano-ec2tag'
  s.summary     = 'A Capistrano plugin aimed at easing the pain of deploying to Amazon EC2 instances.'
  s.description = 'capistrano-ec2tag is a Capistrano plugin designed to simplify the task of deploying to infrastructure hosted on Amazon EC2. It was completely inspired by the capistrano-ec2group plugin, to which all credit is due.'

  s.rubyforge_project = 'capistrano-ec2tag'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'capistrano', '>=2.1.0'
  s.add_dependency 'aws-sdk'
end
