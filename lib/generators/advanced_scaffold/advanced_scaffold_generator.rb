require 'rails/generators/migration'
require 'rails/generators/generated_attribute'

module AdvancedScaffoldGenerator
  module Generators
    class AdvancedScaffoldGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      namespace "advanced_scaffold"
      attr_accessor :scaffold_name, :model_attributes, :controller_actions

      source_root File.expand_path('../templates', __FILE__)


      argument  :advanced_scaffold_name, :type => :string, :required => true,  :banner => 'ModelName'
      argument  :args_for_c_m,  :type => :array,  :default => [],   :banner => 'controller_actions and model:attributes'

      class_option  :skip_model,  :desc =>  'Don\'t generate a model or migration file.', :type => :boolean
      class_option  :skip_migration,  :desc => 'Don\'t generate migration file for model.', :type => :boolean
      class_option  :skip_controller, :desc => 'Don\'t generate controller, helper, or views', :type => :boolean

      def initialize(*args, &block)
        super
#    print_usage unless advanced_scaffold_name.underscore =~ /^[a-z][a-z0-9_\/]+$/
        puts "advanced_scaffold_name=#{advanced_scaffold_name}"
        
        @controller_actions = []
        @model_attributes   = []
        @skip_model = options.skip_model?

        args_for_c_m.each do  |arg|
          if arg.include?(':')
            puts "model: #{arg}"
            @model_attributes <<  Rails::Generators::GeneratedAttribute.new(*arg.split(':'))
          else
            puts "controller: #{arg}"
            @controller_actions <<  arg
          end
        end

        @controller_actions.uniq!
        @model_attributes.uniq!

        @controller_actions = all_actions if @controller_actions.empty?

        @skip_model = true if @model_attributes.empty?
      end

      def copy_js
        copy_file("advanced_scaffold.js", "public/javascripts/advanced_scaffold.js")
      end
      def copy_css
        copy_file("css/advanced_scaffold.css", "public/stylesheets/advanced_scaffold.css")
      end
      def copy_images
        copy_file("images/down_arrow.gif", "public/images/advanced_scaffold/down_arrow.gif")
        copy_file("images/up_arrow.gif", "public/images/advanced_scaffold/up_arrow.gif")
      end
#      def add_config
#        inject_into_file "config/application.rb", :after => "config.action_view.javascript_expansions" do
#          "config.action_view.javascript_expansions[:defaults] << %w(advanced_scaffold)"
#        end
      def create_model
        template 'model.rb',  "app/models/#{model_path}.rb" unless @skip_model
      end

      def create_migration
        unless @skip_model || options.skip_migration?
          migration_template  'migration.rb', "db/migrate/create_#{model_path.pluralize.gsub('/', '_')}.rb"
        end
      end

      def create_controller
        unless options.skip_controller?
          template  'controller.rb',  "app/controllers/#{plural_name}_controller.rb"
          template  'helper.rb',  "app/helpers/#{plural_name}_helper.rb"
          controller_actions.each do |action|
            if %w[index show new edit].include?(action)
              template "views/#{action}.html.erb",  "app/views/#{plural_name}/#{action}.html.erb"
            end
          end

          if form_partial?
            template  "views/_form.html.erb", "app/views/#{plural_name}/_form.html.erb"
          end
          if index_partial?
            template  "views/_index.html.erb", "app/views/#{plural_name}/_index.html.erb"
            template  "views/_search.html.erb", "app/views/#{plural_name}/_search.html.erb"
          end
          if index_js?
            template  "views/index.js.erb", "app/views/#{plural_name}/index.js.erb"
          end
          namespaces = plural_name.split('/')
          resource = namespaces.pop
          route namespaces.reverse.inject("resources :#{resource}") { |acc, namespace|
            "namespace(:#{namespace}){ #{acc} }"
          }
        end
      end

    private

      def form_partial?
        actions?  :new, :edit
      end

      def index_partial?
        actions?  :index
      end
      
      def index_js?
        actions?  :index
      end


      def action?(name)
        controller_actions.include? name.to_s
      end

      def actions?(*names)
        names.all? { |name| action? name }
      end
      
      def class_name
        advanced_scaffold_name.split('::').last.camelize
      end

      def plural_class_name
        plural_name.camelize
      end

      def model_path
        class_name.underscore
      end

      def all_actions
        %w[index show new create edit update destroy]
      end

      def plural_name
        advanced_scaffold_name.underscore.pluralize
      end

      def singular_name
        advanced_scaffold_name.underscore
      end
      
      def table_name
        plural_name.split('/').last
      end

      def instance_name
        singular_name.split('/').last
      end

      def namespace
        singular_name.include?('/') ? singular_name.split('/').first : ""
      end
      def namespace_part
        singular_name.include?('/') ? singular_name.split('/').first+"_" : ""
      end

      def instances_url
        namespace_part + instances_name + "_url"
      end

      def instances_path
        namespace_part + instances_name + "_path"
      end

      def instance_path
        namespace_part + instance_name + "_path"
      end


      def instances_name
        instance_name.pluralize
      end

      def print_usage
        self.class.help(Thor::Base.shell.new)
        exit
      end

      def controller_methods(dirname)
        controller_actions.map do |action|
          read_template("#{dirname}/#{action}.rb")
        end.join("\n").strip
      end

      def read_template(relative_path)
        ERB.new(File.read(find_in_source_paths(relative_path)), nil, '-').result(binding)
      end

      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          Time.now.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end
    end
  end
end
