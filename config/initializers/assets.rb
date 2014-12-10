# -*- encoding : utf-8 -*-
# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
#Rails.application.config.assets.precompile += %w(items.js admin.js admin.css html5shiv.js respond.js ie.l9.js)
Rails.application.config.assets.precompile += %w(shop.css)
Rails.application.config.assets.precompile += %w(ie6.css ie6.js html5*.js jquery.lazyload.js home.js inhome_manage.js cat_stores.js entries.js)
