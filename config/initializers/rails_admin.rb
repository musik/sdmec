RailsAdmin.config do |config|

require 'i18n'
#I18n.default_locale = 'zh-CN'
  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.excluded_models = [ 'Ct', 'Dache', 'Huati', 'Item',  'PageView', 'Role',  'Tc', 'Topic']
  config.excluded_models += %w(SiteStore Tbpage Cat)
  Rails.application.eager_load!
  config.included_models = ActiveRecord::Base.descendants.map!(&:name)
  #config.included_models = %w(User)
  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    nested_set do
      visible do
        %w(Page Fl::Category).include? bindings[:abstract_model].model_name
      end
    end

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
