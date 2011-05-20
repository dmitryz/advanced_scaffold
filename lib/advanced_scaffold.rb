module AdvancedScaffold
  # Your code goes here...
  module Rails
    class Railtie < ::Rails::Railtie
      config.before_initialize do
        config.action_view.javascript_expansions[:defaults] += %w(advanced_scaffold)
       end
    end
  end
end
