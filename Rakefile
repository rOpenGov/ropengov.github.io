require "rubygems"
require "tmpdir"

require "bundler/setup"
require "jekyll"


# Change your GitHub reponame eg. "kippt/jekyll-incorporated"
GITHUB_REPONAME = "rOpenGov/ropengov.github.io"

namespace :site do
  desc "Generate project table"
  task :projecttable do
    puts "Extracting information for the project table"

    require 'open-uri'
    require 'zip'

    # Current dir
    site_dir = Dir.pwd

    # Check if there are DESCRIPTION files available in the packages
    # listed in _projects dir 
    projects = update_projects()

    # Read URLs for all projects
    urls = read_projects()
    
    # Download the repo zip to a tempdir
    Dir.mktmpdir do |tmp|
      Dir.chdir tmp

      urls.each do |title, url|
        
          begin
            # Construct a HTTPS URL to the package description file
            zip_path = url.gsub("https://github.com", "") + "/archive/master.zip"

            # Get the URI object
            zip_uri = URI::HTTPS.build({:host => 'github.com', 
                                        :path => zip_path})

            puts "Dowloading #{zip_uri}"

            zip_content = zip_uri.read
            zip_file = File.join(title + ".zip")

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
          pkg_folder = File.join(tmp, title + "-master")
          pkg_files = Dir.glob(pkg_folder + "/**/*")

          if pkg_files.length == 0
            abort "ERROR: no files found in #{pkg_folder}"
          end

          # First, we need the content of the Description file
          description = nil
          
          pkg_files.each do |file|
            if file.match(/.*DESCRIPTION$/) 
              # Get the content of the DESCRIPTION-file as a String
              puts "Parsing the content of package DESCRIPTION file"
              description = parse_description(File.open(file, "rb").read)
            end
          end

          # Stop execution if DESCRIPTION could not be found
          if description.nil?
            puts 'Could not find a DESCRIPTION file, exiting'
            exit 1
          end

        # Move back to the site dir
        Dir.chdir site_dir

	# TODO
        # Regenerate project mds
        puts "Creating project md-file for #{title}"
	project = update_description(description)
        File.open("#{title}" + 'check', 'w') {|f| f.write project.to_yaml + '---'}

      end
    end

    puts "DESCRIPTION files scanned."

  end


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


  def update_description(description)

    if description.nil?
      puts 'Could not find DESCRIPTION file, passing'
    else 

      project = {}

      if not(description["Package"].nil?)
        project["Title"] = description["Package"].inspect
      end

      if not(description["Title"].nil?)
        project["description"] = description["Title"].inspect
      end

      if not(description["Maintainer"].nil?)
        project["maintainer"] = description["Maintainer"].inspect
      end

      if not(description["URL"].nil?)
        project["link"] = description["URL"].inspect
      end

      if not(description["BugReports"].nil?)
        project["bugreports"] = description["BugReports"].inspect
      end

      if not(description["URL.CRAN"].nil?)
        project["cran"] = description["URL.CRAN"].inspect
      end

    end

    return(project)

  end


  def update_projects(all=false)
    require 'yaml'

    # Parse all the project files
    project_files = Dir.glob('_projects/*.md')
    projects = {}

    puts "Scanning package DESCRIPTION files in GitHub..."

    project_files.each do |project_file|
      content = YAML.load_file(project_file)
      if all
        projects[project_file] = content
      else
        if content['category'] == 'ropengov'
          if content['github']
            gh_user = parse_github_user(content['github'])
            if find_description(content['title'], gh_user)
              puts "  DESCRIPTION file found for #{content['title']}"
              content['description'] = true
            else
              puts "  No DESCRIPTION file found for #{content['title']}"
              content['description'] = false
            end
            projects[project_file] = content
          else
            puts "  No GitHub URL defined for #{content['title']}"
          end
        end
      end
    end

    if projects.length == 0
      fail "No projects found in " + File.join(Dir.pwd, '_projects')
    else
      return(projects)
    end
  end


  def read_projects()

    require 'yaml'
    puts "Scanning package URLs..."
    urls = YAML.load_file('_projects/master.list')
    return(urls)

  end


  def find_description(package, gh_user)

    require 'open-uri'
    description_file = "DESCRIPTION" # "#{package}_tutorial.Rmd"
    description_found = false

    url_path = "https://github.com/#{gh_user}/#{package}/blob/master/#{description_file}"
    begin
      open(url_path) do |f|
        description_found = true
      end
    rescue OpenURI::HTTPError => e
    end
    return(description_found)
  end

end

namespace :projects do
  desc "Convert package vignettes to Jekyll pages"
  task :convert_tutorials do 

    require 'open-uri'
    require 'zip'

    # Current dir
    site_dir = Dir.pwd

    # # Check if there are tutorials available in the packages
    # # listed in _projects dir 
    projects = parse_projects()

    # Download the repo zip to a tempdir
    Dir.mktmpdir do |tmp|
      Dir.chdir tmp

      projects.each do |project_file, project|
        
        if (project.key?('github') && project.key?('tutorial') && project['tutorial'] == true)

          begin
            # Construct a HTTPS URL to the package description file
            zip_path = "#{project['github']}".gsub("https://github.com", "") + "/archive/master.zip"

            # Get the URI object
            zip_uri = URI::HTTPS.build({:host => 'github.com', 
                                        :path => zip_path})
            puts "Dowloading #{zip_uri}"
            zip_content = zip_uri.read
            zip_file = "#{project['title']}.zip"
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
          pkg_folder = File.join(tmp, project['title'] + "-master")
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

          if pkg_files.length == 0
            abort "ERROR: no files found in #{pkg_folder}"
          end

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
            exit 1
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

          # [fixme] - GitHub username parsing assumes a GH URL is present
          # Construct a hash to hold the Front Matter data
          description["Author"] = [description["Author"]]
          fm_hash = {
            "title" => "#{project['title']} vignette",
            "layout" => "tutorial_page",
            "package_name" => project['title'],
            "package_name_show" => project['title'],
            "author" => description["Author"].join(', '),
            "meta_description" => description["Description"],
            "github_user" => parse_github_user(project['github']),
            "package_version" => description["Version"],
            "header_descripton" => description["Description"]
          }
          
          fm_string = generate_front_matter(fm_hash)

          # [fixme] - has not been tested with multiple files. Currently
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
              tutorial_filename = File.join(site_dir, "tutorials", "#{project['title']}_tutorial.Rmd")
              puts "Writing tutorial file #{tutorial_filename}"
              File.open(tutorial_filename, 'w') {|f| f.write(tutorial_content) }
            end
          end

          # Install the actual package
          cran_mirror = "http://cran.rstudio.com"
          puts "Installing R-package #{project['title']}"
          cmd_string = ["R --vanilla --silent -e 'options(repos = c(CRAN=#{cran_mirror.inspect}))", 
                        "library(devtools)",
                        "install(#{pkg_folder.inspect}, dependencies=TRUE, build_vignettes=FALSE)'"].join("; ")

          cmd_status = system cmd_string
          if !cmd_status
            fail "R-package installation failed, exiting"
          end
        end
      end
      # Move back to the site dir
      Dir.chdir site_dir
      # Regenerate project mds
      projects.each do |project_file, project|
        puts "Updating project md-file #{project_file}"
        File.open("#{project_file}", 'w') {|f| f.write project.to_yaml + '---'}
      end
    end

    # knit the Rmd-tutorial files
    puts "Knitting all Rmd-files in folder 'tutorials'"
    cmd_status = system "./_knittutorials.R --force"
    if !cmd_status
      fail "Rmd file knitting failed, exiting"
    end

    # fig.options in _knittutorials.R is set relative to the site root folder, i.e.
    # images created by knitr will be placed in 'figs' folder in the site root.
    # Jekyll will, however, run the tutorial in URL
    # {{ BASE_URL }}/tutorial/{{ package_name }}_tutorial/
    # and will not find the 'figs' folder which relative path is now
    # {{ BASE_URL }}/tutorial/{{ package_name }}_tutorial/../../figs/
    # Manually correct for this
    #
    # WARNING! Awful hack! Repent! 
    Dir.chdir("tutorials") do
      md_files = Dir.glob('*.md')
      
      md_files.each do |md_file|
        puts "Fixing image paths in tutorials/#{md_file}"
        outdata = File.read(md_file).gsub(/\(figs\//, "(../../figs/")

        File.open(md_file, 'w') do |out|
          out << outdata
        end  
      end
    end

    # Regenerate the site
    puts "Regenerating the site"
    Jekyll::Site.new(Jekyll.configuration({
      "source"      => ".",
      "destination" => "_site",
      "url"         => "http://ropengov.github.io"
    })).process

  end

  desc "List site projects"
  task :list do
    
    require 'table_print'

    projects = parse_projects()
    # Convert from hash to array
    content = []
    projects.each do |project_file, project|
      content << project
    end
    puts "\n"
    tp content, :title, {:description => {:width => 60}}, :tutorial
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

  def generate_front_matter(data)
    return("---\n#{data.map{|k,v| "#{k}: #{v}"}.join("\n")}\n---\n\n")
  end

  def parse_github_user(url)
    return(url.split("/")[3].downcase)
  end

  def parse_projects(all=false)
    require 'yaml'

    # Parse all the project files
    project_files = Dir.glob('_projects/*.md')
    projects = {}

    puts "Looking for package tutorials in GitHub..."

    project_files.each do |project_file|
      content = YAML.load_file(project_file)
      if all
        projects[project_file] = content
      else
        if content['category'] == 'ropengov'
          if content['github']
            gh_user = parse_github_user(content['github'])
            if find_tutorial(content['title'], gh_user)
              puts "  Tutorial found for #{content['title']}"
              content['tutorial'] = true
            else
              puts "  No tutorial found for #{content['title']}"
              content['tutorial'] = false
            end
            projects[project_file] = content
          else
            puts "  No GitHub URL defined for #{content['title']}"
          end
        end
      end
    end

    if projects.length == 0
      fail "No projects found in " + File.join(Dir.pwd, '_projects')
    else
      return(projects)
    end
  end

  def find_tutorial(package, gh_user)

    require 'open-uri'
    vignette_file = "#{package}_tutorial.Rmd"
    tutorial_found = false

    url_path = "https://github.com/#{gh_user}/#{package}/blob/master/vignettes/#{vignette_file}"
    begin
      open(url_path) do |f|
        tutorial_found = true
      end
    rescue OpenURI::HTTPError => e
    end
    return(tutorial_found)
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