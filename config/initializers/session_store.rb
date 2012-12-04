# -*- encoding : utf-8 -*-
# Be sure to restart your server when you modify this file.

Tb::Application.config.session_store :cookie_store, key: '_tb_session', :domain => :all

# change top level domain size
#request.domain(2)
#request.subdomain(2)
# Tb::Application.config.session_store :cookie_store, :key => '_blogs_session', :domain => "42foo.com"
# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Tb::Application.config.session_store :active_record_store
