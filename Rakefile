# encoding: utf-8

require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'
require 'spec'
require 'spec/rake/spectask'

task :default => [:spec]

Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ['--options', "spec/spec.opts"]
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec,/*ruby*,']
end

require 'jeweler'
# Fix for Jeweler to use stable branch
class Jeweler
  module Commands
    class ReleaseToGit
      def run
        unless clean_staging_area?
          system "git status"
          raise "Unclean staging area! Be sure to commit or .gitignore everything first. See `git status` above."
        end
        repo.checkout('stable')
        repo.push('origin', 'stable')
        if release_not_tagged?
          output.puts "Tagging #{release_tag}"
          repo.add_tag(release_tag)
          output.puts "Pushing #{release_tag} to origin"
          repo.push('origin', release_tag)
        end
      end
    end
    class ReleaseGemspec
      def run
        unless clean_staging_area?
          system "git status"
          raise "Unclean staging area! Be sure to commit or .gitignore everything first. See `git status` above."
        end
        repo.checkout('stable')
        regenerate_gemspec!
        commit_gemspec! if gemspec_changed?
        output.puts "Pushing stable to origin"
        repo.push('origin', 'stable')
      end
    end
  end
end

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "acts_as_chained"
  gem.homepage = "http://github.com/AMEE/acts_as_chained"
  gem.license = "BSD 3-Clause"
  gem.summary = %Q{An ActiveRecord plugin that adds attribute chaining capabilities to models}
  gem.email = "james@floppy.org.uk"
  gem.authors = ["James Smith"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "acts_as_chained #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
