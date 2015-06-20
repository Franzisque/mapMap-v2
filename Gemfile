##
# Gemfile
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.6'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

###### Gems added by the TEAM ######

# Gems for Development

# Google maps
gem 'gmaps4rails'

# gem for underscore.js
gem 'underscore-rails'

# Nokogiri needed
gem 'nokogiri', '~> 1.6.4.1'

group :development do
    gem 'better_errors'
    gem 'binding_of_caller'
    gem 'letter_opener'
end

# Gems for Tests
group :development, :test do
    gem 'minitest-rails-capybara'
    gem 'poltergeist', '~> 1.5.0'
    gem 'factory_girl_rails', '~> 4.0'
    gem 'jasmine-rails'
end

# User Authentication - Profile
gem 'devise'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'cancancan', '~> 1.10'
gem 'activeadmin', git: 'https://github.com/activeadmin/activeadmin.git'

# Gems for Deployment
group :deployment do
    gem 'capistrano', '~> 2.15.2'
    gem 'rvm-capistrano'

    # therubyracer shouldnt be installed on windows
    gem 'therubyracer', platform: :ruby
end

# gem for timezone information, needed on windows
gem 'tzinfo-data', platforms: [:mingw, :mswin]

# needed to specify rake for server
gem 'rake', '~> 10.3.2'

# gem for postgresql on server
gem 'pg', '~> 0.17.1'

# without this gem no ssh connection possible
gem 'net-ssh', '2.7.0'

# needed for jQuery to run the code when the page has loaded
gem 'jquery-turbolinks'

# Font Awesome Icons
gem 'font-awesome-rails'

# paperclip -> video/image upload
gem 'paperclip', '~> 4.2'
gem 'paperclip-av-transcoder'
gem 'delayed_paperclip'

# background jobs
gem 'sidekiq'

# wizard forms
gem 'wicked'

# read exif data
gem 'exifr'

# jquery file upload
gem 'jquery-fileupload-rails'
