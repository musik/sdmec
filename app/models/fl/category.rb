class Fl::Category < ActiveRecord::Base
  acts_as_nested_set
  rails_admin do
    edit do
      configure :lft do
        hide
      end
      configure :rgt do
        hide
      end
      configure :depth do
        hide
      end
    end
    nested_set({
        max_depth: 1,
        #toggle_fields: [:enabled],
        #thumbnail_fields: [:image, :cover],
        #thumbnail_size: :thumb,
        #thumbnail_gem: :paperclip, # or :carrierwave
    })
  end
end
