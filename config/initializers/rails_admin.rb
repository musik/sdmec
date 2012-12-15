# RailsAdmin config file. Generated on October 26, 2012 22:27
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|


  ################  Global configuration  ################

  # Set the admin name here (optional second array element will appear in red). For example:
  config.main_app_name = ['Tb', 'Admin']
  # or for a more dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

  # RailsAdmin may need a way to know who the current user is]
  config.current_user_method { current_user } # auto-generated
  config.authenticate_with do
    redirect_to '/' unless user_signed_in? and current_user.has_role? :admin
  end

  # If you want to track changes on your models:
  # config.audit_with :history, 'User'

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, 'User'

  # Display empty fields in show views:
  # config.compact_show_view = false

  # Number of default rows per-page:
  # config.default_items_per_page = 20

  # Exclude specific models (keep the others):
  # config.excluded_models = ['Cat', 'Category', 'City', 'Ct', 'Dache', 'Huati', 'Item', 'Link', 'PageView', 'Role', 'Store', 'Tbpage', 'Tc', 'Topic', 'User']
  config.excluded_models = [ 'Ct', 'Dache', 'Huati', 'Item',  'PageView', 'Role',  'Tc', 'Topic', 'User']

  # Include specific models (exclude the others):
  # config.included_models = ['Cat', 'Category', 'City', 'Ct', 'Dache', 'Huati', 'Item', 'Link', 'PageView', 'Role', 'Store', 'Tbpage', 'Tc', 'Topic', 'User']

  # Label methods for model instances:
  # config.label_methods << :description # Default is [:name, :title]


  ################  Model configuration  ################

  # Each model configuration can alternatively:
  #   - stay here in a `config.model 'ModelName' do ... end` block
  #   - go in the model definition file in a `rails_admin do ... end` block
  
  # This is your choice to make:
  #   - This initializer is loaded once at startup (modifications will show up when restarting the application) but all RailsAdmin configuration would stay in one place.
  #   - Models are reloaded at each request in development mode (when modified), which may smooth your RailsAdmin development workflow.


  # Now you probably need to tour the wiki a bit: https://github.com/sferik/rails_admin/wiki
  # Anyway, here is how RailsAdmin saw your application's models when you ran the initializer:



  ###  Cat  ###

  # config.model 'Cat' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your cat.rb model definition
  
  #   # Found associations:

  #     configure :parent, :belongs_to_association 
  #     configure :children, :has_many_association 
  #     configure :roles, :has_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :name, :string 
  #     configure :slug, :string 
  #     configure :oid, :string 
  #     configure :parent_id, :integer         # Hidden 
  #     configure :lft, :integer 
  #     configure :rgt, :integer 
  #     configure :depth, :integer 

  #   # Cross-section configuration:
  
  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  
  #   # Section specific configuration:
  
  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Category  ###

   config.model 'Category' do

     # You can copy this to a 'rails_admin do ... end' block inside your category.rb model definition
  
     # Found associations:

       #configure :parent, :belongs_to_association 
       #configure :children, :has_many_association 
       #configure :roles, :has_many_association 

     # Found columns:

       configure :id, :integer 
       configure :name, :string 
       configure :display, :boolean 
       configure :slug, :string 
       configure :priority, :integer 
       configure :cid, :integer 
       configure :parent_cid, :integer 
       configure :is_parent, :boolean 
       configure :children_fetched, :boolean 
       configure :status, :string 
       configure :sort_order, :integer 
       configure :created_at, :datetime 
       configure :updated_at, :datetime 
       configure :parent_id, :integer         # Hidden 
       configure :lft, :integer 
       configure :rgt, :integer 
       configure :depth, :integer 
       configure :nicename, :string 
       configure :keywords, :string 

     # Cross-section configuration:
  
       # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
       # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
       # label_plural 'My models'      # Same, plural
       # weight 0                      # Navigation priority. Bigger is higher.
       # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
       # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  
     # Section specific configuration:
  
       list do
         filters [:display,:parent]  # Array of field names which filters should be shown by default in the table header
         items_per_page 100    # Override default_items_per_page
         sort_by :display           # Sort column (default is primary key)
         # sort_reverse true     # Sort direction (default is true for primary key, last created first)o

         field :name
         field :display
         field :parent_id do
           read_only true
         end
         field :nicename
         field :slug
         field :keywords
         field :priority
       end
       show do; end
       edit do
        #field :name
        #field :display
        #field :slug
        #field :nicename
        #field :keywords
        #field :priority
       end
       export do; end
       # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
       # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
       # using `field` instead of `configure` will exclude all other fields and force the ordering
   end


  ###  City  ###

  # config.model 'City' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your city.rb model definition
  
  #   # Found associations:



  #   # Found columns:

  #     configure :id, :integer 
  #     configure :name, :string 
  #     configure :slug, :string 
  #     configure :parent_id, :integer 
  #     configure :use_subdomain, :boolean 
  #     configure :zhixiashi, :boolean 

  #   # Cross-section configuration:
  
  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  
  #   # Section specific configuration:
  
  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Ct  ###

  # config.model 'Ct' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your ct.rb model definition
  
  #   # Found associations:



  #   # Found columns:

  #     configure :city_id, :integer 
  #     configure :topic_id, :integer 
  #     configure :items_count, :integer 
  #     configure :itemsdata, :text 
  #     configure :fetched, :boolean 
  #     configure :fetched_at, :datetime 

  #   # Cross-section configuration:
  
  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  
  #   # Section specific configuration:
  
  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Dache  ###

  # config.model 'Dache' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your dache.rb model definition
  
  #   # Found associations:



  #   # Found columns:

  #     configure :id, :integer 
  #     configure :context_type, :string 
  #     configure :context_id, :integer 
  #     configure :value, :text 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:
  
  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  
  #   # Section specific configuration:
  
  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Huati  ###

  # config.model 'Huati' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your huati.rb model definition
  
  #   # Found associations:

  #     configure :roles, :has_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :name, :string 
  #     configure :slug, :string 
  #     configure :content, :string 
  #     configure :acr, :string 
  #     configure :acr2, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :published, :boolean 
  #     configure :priority, :integer 
  #     configure :delta, :boolean 

  #   # Cross-section configuration:
  
  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  
  #   # Section specific configuration:
  
  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Item  ###

  # config.model 'Item' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your item.rb model definition
  
  #   # Found associations:



  #   # Found columns:

  #     configure :id, :integer 
  #     configure :title, :string 
  #     configure :price, :integer 
  #     configure :commission, :integer 
  #     configure :commission_num, :integer 
  #     configure :commission_rate, :integer 
  #     configure :commission_volume, :integer 
  #     configure :item_location, :string 
  #     configure :nick, :string 
  #     configure :num_iid, :string 
  #     configure :seller_credit_score, :integer 
  #     configure :volume, :integer 
  #     configure :pic_url, :string 
  #     configure :click_url, :string 
  #     configure :shop_click_url, :string 
  #     configure :cid, :integer 
  #     configure :delist_time, :datetime 
  #     configure :desc, :text 
  #     configure :detail_url, :string 
  #     configure :location_city, :string 
  #     configure :location_state, :string 
  #     configure :express_fee, :integer 
  #     configure :sell_promise, :boolean 
  #     configure :detail_updated_at, :datetime 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:
  
  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  
  #   # Section specific configuration:
  
  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Link  ###

  # config.model 'Link' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your link.rb model definition
  
  #   # Found associations:

  #     configure :roles, :has_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :data, :text 
  #     configure :name, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:
  
  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  
  #   # Section specific configuration:
  
  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  PageView  ###

  # config.model 'PageView' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your page_view.rb model definition
  
  #   # Found associations:

  #     configure :viewable, :polymorphic_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :viewable_type, :string         # Hidden 
  #     configure :viewable_id, :integer         # Hidden 
  #     configure :user_agent, :string 
  #     configure :ip, :string 
  #     configure :referer, :string 
  #     configure :visitor_hash, :string 
  #     configure :user_id, :integer 
  #     configure :created_at, :datetime 

  #   # Cross-section configuration:
  
  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  
  #   # Section specific configuration:
  
  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Role  ###

  # config.model 'Role' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your role.rb model definition
  
  #   # Found associations:

  #     configure :resource, :polymorphic_association 
  #     configure :users, :has_and_belongs_to_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :name, :string 
  #     configure :resource_id, :integer         # Hidden 
  #     configure :resource_type, :string         # Hidden 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:
  
  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  
  #   # Section specific configuration:
  
  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Store  ###

  # config.model 'Store' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your store.rb model definition
  
  #   # Found associations:

  #     configure :city, :belongs_to_association 
  #     configure :category, :belongs_to_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :title, :string 
  #     configure :user_id, :integer 
  #     configure :city_id, :integer         # Hidden 
  #     configure :seller_credit, :integer 
  #     configure :shop_type, :string 
  #     configure :click_url, :string 
  #     configure :commission_rate, :integer 
  #     configure :total_auction, :integer 
  #     configure :auction_count, :integer 
  #     configure :sid, :integer 
  #     configure :cid, :integer         # Hidden 
  #     configure :nick, :string 
  #     configure :desc, :text 
  #     configure :bulletin, :text 
  #     configure :pic_path, :string 
  #     configure :created, :datetime 
  #     configure :modified, :datetime 
  #     configure :delivery_score, :integer 
  #     configure :item_score, :integer 
  #     configure :service_score, :integer 
  #     configure :taoke_updated_at, :datetime 
  #     configure :shop_updated_at, :datetime 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :buyer_credit, :integer 
  #     configure :hangye, :string 
  #     configure :seller_rate, :integer 
  #     configure :user_updated_at, :datetime 
  #     configure :comments_updated_at, :datetime 
  #     configure :seller_score, :integer 
  #     configure :delta, :boolean 

  #   # Cross-section configuration:
  
  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  
  #   # Section specific configuration:
  
  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Tbpage  ###

  # config.model 'Tbpage' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your tbpage.rb model definition
  
  #   # Found associations:

  #     configure :roles, :has_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :name, :string 
  #     configure :slug, :string 
  #     configure :tburl, :string 
  #     configure :last_fetched_at, :datetime 
  #     configure :tagid, :integer 

  #   # Cross-section configuration:
  
  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  
  #   # Section specific configuration:
  
  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Tc  ###

  # config.model 'Tc' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your tc.rb model definition
  
  #   # Found associations:

  #     configure :topic, :belongs_to_association 
  #     configure :city, :belongs_to_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :topic_id, :integer         # Hidden 
  #     configure :city_id, :integer         # Hidden 

  #   # Cross-section configuration:
  
  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  
  #   # Section specific configuration:
  
  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Topic  ###

  # config.model 'Topic' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your topic.rb model definition
  
  #   # Found associations:

  #     configure :page_views, :has_many_association 
  #     configure :roles, :has_many_association 
  #     configure :cts, :has_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :name, :string 
  #     configure :slug, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :volume, :integer 
  #     configure :acr, :string 
  #     configure :acr2, :string 
  #     configure :items_updated_at, :datetime 
  #     configure :public, :boolean 
  #     configure :delta, :boolean 

  #   # Cross-section configuration:
  
  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  
  #   # Section specific configuration:
  
  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  User  ###

  # config.model 'User' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your user.rb model definition
  
  #   # Found associations:

  #     configure :roles, :has_and_belongs_to_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :email, :string 
  #     configure :password, :password         # Hidden 
  #     configure :password_confirmation, :password         # Hidden 
  #     configure :reset_password_token, :string         # Hidden 
  #     configure :reset_password_sent_at, :datetime 
  #     configure :remember_created_at, :datetime 
  #     configure :sign_in_count, :integer 
  #     configure :current_sign_in_at, :datetime 
  #     configure :last_sign_in_at, :datetime 
  #     configure :current_sign_in_ip, :string 
  #     configure :last_sign_in_ip, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :name, :string 

  #   # Cross-section configuration:
  
  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  
  #   # Section specific configuration:
  
  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end

end
