MultiMediaProject 3 - MapMap
==============

Credits
--------------

**University:**
*University of Applied Sciences Salzburg*

**Authors:**
- Franziska Oberhauser
- Manuel Mitterer
- Stephan Griessner

Information
--------------

**Project relevant files are on Dropbox:**
Link: https://www.dropbox.com/sh/azki1d0hkbyqw20/AABQss2GxVhWemHBbh9jwDx5a?dl=0

**Google Doc:**
Link: https://docs.google.com/document/d/1Z3eo6vf8JBlVL7CqjlLChpugDbcKpIqOKQAkfWVbQbk/edit?pli=1

**File needed to run this rails app:**
- config/secrets.yml
- config/database.yml

*Contact Stephan Griessner if you want to run this application on your computer*


What you need on your computer (installed with homebrew)
--------------

**Imagemagick:**

    brew install imagemagick


**Libav (to convert videos):**

    brew install libav


**Redis (for Background-Jobs):**

    brew install redis


What you need to run in the terminal on your computer (for Video upload)
--------------

**Start Redis:**

    redis-server /usr/local/etc/redis.conf

**Start Sidekiq:**

	bundle exec sidekiq -q paperclip


How to become an Admin
--------------

**Development:**

Visit the url
	http://localhost:3000/admin

E-Mail: admin@example.com
PW: password


**Production:**

*Contact Stephan Griessner if you want to become an Admin for the online App*

	http://mapmap.mediacube.at/admin

We need your E-Mail Address to add you as an admin


What you need to run in your terminal to run this app
--------------
**Install Gems:**
	bundle install

**Migrations:**
	rake db:migrate

**Seed Database:**
	rake db:seed

**Start Webrick Server:**
	rails s

--------------

**Testing:**

*Rails tests:
- To run the rails tests enter the command:
  $ rake test


*JavaScript test:
- Open your browser and add '/specs' to your root localhost url e.g.:
http://localhost:3000/specs

The test environment is set up with jasmine.
For further information please visit: http://jasmine.github.io/

--------------

Code convention:
--------------
- use 4 spaces for (tab-) indent



