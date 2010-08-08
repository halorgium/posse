ActionView::Helpers::AssetTagHelper.register_javascript_expansion :jquery => ['jquery', 'jquery-ui', 'rails']
Rails.application.config.action_view.javascript_expansions[:defaults] = ['jquery', 'jquery-ui', 'rails']
