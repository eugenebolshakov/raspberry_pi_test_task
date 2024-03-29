This is a tech task which is part of interview process for Senior Software
Engineer role at Raspberry Pi Foundation.

# Task

Design and Build a "Users" JSON REST API (choosing the appropriate language /
framework):

* implement creation, reading and deletion of users
* for deletion of a user, an API key secretkey should be provided in the
  request as you see fit
* have a User model which has the following attributes: username, email,
  password. Feel free to add others if you wish
* have a User model which should persist, but there's no expectation that the
  storage engine would be used in production, so a flat file database such as
  SQLite would be fine
* have passwords which are stored securely
* have some sort of documentation (tests are fine)

# Setup

* Install Ruby (version 2.6.3 was used for this task)
* Run `bundle install`
* Set ENV variables (see `.env.source` for a list of variables)
* Run `rake setup`

# Use

* Start the app with `rake start`
* Run tests with `rake test`
