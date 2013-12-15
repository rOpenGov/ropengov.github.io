require "rubygems"
require "tmpdir"

require "bundler/setup"
require "jekyll"


# Change your GitHub reponame eg. "kippt/jekyll-incorporated"
GITHUB_REPONAME = "rOpenGov/ropengov.github.io"


namespace :site do
  desc "Generate blog files"
  task :generate do
    Jekyll::Site.new(Jekyll.configuration({
      "source"      => ".",
      "destination" => "_site",
      "url"         => "http://ropengov.github.io"
    })).process
  end

  desc "Run Jekyll server with production config"
  task :run => [:generate] do
    puts "Rakefile: Running Jekyll server with a production configuration."
    system "jekyll serve --watch --config _production_config.yml,_config.yml"
  end

  desc "Run Jekyll server with development config"
  task :run_dev => [:generate] do
    puts "Rakefile: Running Jekyll server with a development configuration."
    system "jekyll serve --watch --config _development_config.yml,_config.yml"
  end

  desc "Generate and publish blog to master"
  task :publish => [:generate] do
    Dir.mktmpdir do |tmp|
      cp_r "_site/.", tmp
      Dir.chdir tmp
      system "git init"
      system "git add ."
      message = "Site updated at #{Time.now.utc}"
      system "git commit -m #{message.inspect}"
      system "git remote add origin git@github.com:#{GITHUB_REPONAME}.git"
      system "git push origin master:refs/heads/master --force"
    end
  end
end
