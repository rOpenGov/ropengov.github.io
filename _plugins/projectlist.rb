# Title: Project list tag for Jekyll
# Author: Frederic Hemberger http://frederic-hemberger.de
# Description: TODO ;-)
#
# Syntax {% projectlist [template] %}
#
# Example:
# {% projectlist my_template.html %}
module Jekyll

  class Project
    include Convertible

    attr_accessor :data, :content
    attr_accessor :projectdata
    attr_accessor :site

    def initialize(site, base, dir, name)
      @site = site
      @projectdata = self.read_yaml(File.join(base, dir), name)
      @projectdata['content'] = markdownify(self.content)
    end

    def publish?
      @projectdata['published'].nil? or @projectdata['published'] != false
    end

    # Convert a Markdown string into HTML output.
    #
    # input - The Markdown String to convert.
    #
    # Returns the HTML formatted String.
    def markdownify(input)
      converter = @site.find_converter_instance(Jekyll::Converters::Markdown)
      converter.convert(input)
    end
  end


  class ProjectList
    @@projects = []

    def self.create(site)
      @@projects = []
      dir = site.config['projects_dir'] || '_projects'
      puts dir
      base = File.join(site.source, dir)
      return unless File.exists?(base)

      entries  = Dir.chdir(base) { Dir.glob("*.md").sort }

      # Reverse chronological order
      entries = entries.sort
      entries.each do |f|
          project = Project.new(site, site.source, dir, f)
          @@projects << project.projectdata if project.publish?
      end
    end

    def self.projects
      @@projects
    end
  end


  # Jekyll hook - the generate method is called by jekyll, and generates all of the category pages.
  class GenerateProjects < Generator
    safe true
    priority :low

    def generate(site)
      ProjectList.create(site)
    end
  end


  class ProjectlistTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      @projects = ProjectList.projects
      args = markup.split(' ')
      @template_file = args[0]
      category = args[1]
      
      # Take only the projects that match provided category
      @selected_projects = []
      @projects.each do |project|
        if project['category'] == category
          @selected_projects << project
        end
      end

      super
    end

    def load_teplate(file, context)
      includes_dir = File.join(context.registers[:site].source, '_includes')

      if File.symlink?(includes_dir)
        return "Includes directory '#{includes_dir}' cannot be a symlink"
      end

      if file !~ /^[a-zA-Z0-9_\/\.-]+$/ || file =~ /\.\// || file =~ /\/\./
        return "Include file '#{file}' contains invalid characters or sequences"
      end

      Dir.chdir(includes_dir) do
        choices = Dir['**/*'].reject { |x| File.symlink?(x) }
        if choices.include?(file)
          source = File.read(file)
        else
          "Included file '#{file}' not found in _includes directory"
        end
      end

    end

    def render(context)
      output = super
      template = load_teplate(@template_file, context)

      Liquid::Template.parse(template).render('projects' => @selected_projects).gsub(/\t/, '')
    end
  end


end

Liquid::Template.register_tag('projectlist', Jekyll::ProjectlistTag)
