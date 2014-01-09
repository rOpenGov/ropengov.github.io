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

namespace :tutorial do
  desc "Convert package vignettes to Jekyll pages"
  task :add, [:username, :repo] do |t, args| 

    require 'open-uri'
    require 'zip'

    # Current dir
    site_dir = Dir.pwd

    # Download the repo zip to a tempdir
    Dir.mktmpdir do |tmp|
      Dir.chdir tmp

      begin
        # Construct a HTTPS URL to the package description file
        zip_path = "/#{args.username}/#{args.repo}/archive/master.zip"
        # Get the URI object
        zip_uri = URI::HTTPS.build({:host => 'github.com', 
                                    :path => zip_path})
        puts "Dowloading #{zip_uri}"
        zip_content = zip_uri.read
        zip_file = "#{args.repo}.zip"
        open(zip_file, 'wb') do |fo|
          fo.print zip_content
        end

      rescue OpenURI::HTTPError => e
        puts "Reading #{zip_uri} failed"
        puts "Error message: #{e}"  
      end

      # Unzip the zip file
      unzip_file(zip_file, tmp)
      
      # FIXME: hardcoding '-master' not a good idea
      pkg_folder = File.join(tmp, args.repo + "-master")
      # zip might have a 'pkg' subfolder structure
      subdirs = Dir.glob(pkg_folder + "**/*/")
      unless subdirs.empty?
        subdirs.each do |dir|
          if dir.include? "pkg"
            pkg_folder = File.join(pkg_folder, "pkg")
          end
        end
      end

      pkg_files = Dir.glob(pkg_folder + "/**/*")
      
      # First, we need the content of the Description file
      description = nil
      
      pkg_files.each do |file|
        # Only get *.Rmd-files in vignettes directory
        if file.match(/.*DESCRIPTION$/) 
          puts "Parsing the content of package DESCRIPTION file"
          # Get the content of the DESCRIPTION-file as a String
          description = parse_description(File.open(file, "rb").read)
        end
      end

      # Stop execution if DESCRIPTION could not be found
      if description.nil?
        puts 'Could not find a DESCRIPTION file, exiting'
        exit
      end

      # YAML Front Matter template
      # ---
      # title: sotkanet vignette
      # layout: package_page
      # package_name: sotkanet
      # package_name_show: sotkanet
      # author: Leo Lahti
      # meta_description: Sotkanet API R tools
      # github_user: ropengov
      # package_version: 0.9.01
      # header_descripton: Sotkanet API R tools
      # ---

      # Construct a hah to hold the Front Matter data
      fm_hash = {
        "title" => "#{args.repo} vignette",
        "layout" => "package_page",
        "package_name" => "#{args.repo}",
        "package_name_show" => "#{args.repo}",
        "author" => description["Author"].join(', '),
        "meta_description" => description["Description"],
        "github_user" => "#{args.username}",
        "package_version" => description["Version"],
        "header_descripton" => description["Description"]
      }
      
      fm_string = "---\n#{fm_hash.map{|k,v| "#{k}: #{v}"}.join("\n")}\n---\n\n"

      # FIXME: has not been tested with multiple files. Currently
      # the work logic assumes only one vignette per package.
      pkg_files.each do |file|
        # Only get *.Rmd-files in vignettes directory
        if file.match(/vignettes\/.*\.Rmd/) 
          puts "Parsing the content of #{file}"
          # Get the content of the Rmd-file as a String
          rmd_content = File.open(file, "rb").read
          # Remove the knitr vignette chunk for regular packages
          rmd_content = rmd_content.gsub(/<!--(.|\s|\n)*?-->/, '')
          tutorial_content = fm_string + rmd_content
          # Write the Front Matter + the vignette Rmd-file content to 
          # a new Rmd file
          tutorial_filename = File.join(site_dir, "tutorials", "#{args.repo}_tutorial.Rmd")
          puts "Writing tutorial file #{tutorial_filename}"
          File.open(tutorial_filename, 'w') {|f| f.write(tutorial_content) }
        end
      end

      # Install the actual package
      puts "Installing R-package #{args.repo}"
      cmd_status = system "R --vanilla --silent -e 'library(devtools); install(#{pkg_folder.inspect}, dependencies=TRUE)'"
      if !cmd_status
        puts "R-package installation failed, exiting"
        exit
      end

      # Move back to the site dir
      Dir.chdir site_dir
    end

    # knit the Rmd-tutorial files
    puts "Knitting Rmd-files in folder 'tutorials'"
    cmd_status = system "./_knittutorials.R --force"
    if !cmd_status
      puts "Rmd file knitting failed, exiting"
      exit
    end

    # Regenerate the site
    puts "Regenerating the site"
    Jekyll::Site.new(Jekyll.configuration({
      "source"      => ".",
      "destination" => "_site",
      "url"         => "http://ropengov.github.io"
    })).process

  end

  def parse_description(desc_content)
    # If a newline is followed by whitespace, replace with ', '. 
    desc_content = desc_content.gsub(/\n\s+/, ', ')
    # Split by newline
    desc_content = desc_content.split(/\r?\n/)
    # Parse DESCRIPTION content to a hash
    desc_hash = {}
    desc_content.each do |d|
      key, value = d.split(':', 2).collect{|x| x.strip}
      # Split multivalue strings
      value = value.split(',').collect{|x| x.strip}
      if value.length > 1
        value = value.collect{|x| x.gsub("'", "")}
        value = value.reject{|x| x.empty? }
      else
        value = value[0]
      end
      desc_hash[key] = value
    end
    
    return(desc_hash)
  end

  def unzip_file (file, destination)
    Zip::File.open(file) { |zip_file|
      zip_file.each { |f|
        f_path=File.join(destination, f.name)
        FileUtils.mkdir_p(File.dirname(f_path))
        zip_file.extract(f, f_path) unless File.exist?(f_path)
      }
    }
  end
end