require 'rake'

task :default do
  require 'rspec'
  require File.expand_path('../spec/spec_helper', __FILE__)
  system 'bundle exec rspec spec'
end

task :publish do
  NAME = 'mongoid-autoinc'
  VERSION_FILE = 'lib/autoinc/version.rb'

  def build_and_push_gem
    puts '# Building gem'
    puts `gem build #{NAME}.gemspec`
    puts '# Publishing Gem'
    puts `gem push #{NAME}-#{gem_version}.gem`
  end

  def create_and_push_tag
    begin
      puts `git fetch tags`
      puts `git commit -am 'Bump to #{version} [ci skip]'`
      puts "# Creating tag #{version}"
      puts `git tag #{version}`
      puts `git push origin #{version}`
      puts `git push origin master`
    rescue
      raise "Tag: '#{version}' already exists"
    end
  end

  def changes
    git_status_to_array(`git status --short --untracked-files`)
  end

  def gem_version
    Mongoid::Autoinc::VERSION
  end

  def version
    @version ||= 'v' << gem_version
  end

  def git_status_to_array(changes)
    changes.split("\n").each { |change| change.gsub!(/^.. /,'') }
  end

  raise '$EDITOR should be set' unless ENV['EDITOR']
  raise 'Branch should hold no uncommitted file change)' unless changes.empty?
  raise 'Your editor exited with non-zero status' unless system("$EDITOR #{VERSION_FILE}")
  raise "Expected change in: #{VERSION_FILE}" unless changes.member?(VERSION_FILE)

  load File.expand_path(VERSION_FILE)
  create_and_push_tag
  build_and_push_gem
end
