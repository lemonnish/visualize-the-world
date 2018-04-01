# Visualize the World, built with Ruby on Rails

The live app is hosted on Heroku:
[https://visualize-the-world.herokuapp.com](https://visualize-the-world.herokuapp.com)

This app allows a user to log in and generate maps, where each map can have selected countries and text tied to that selected country. Every map can be displayed using a variety of map projections.

## Project motivation

This project was born from a desire to fulfill two goals:
1. As a world traveller, I wanted a simple and aesthetically appealing way to track my world travels.
2. I wanted to expand my technical skills by building a Ruby on Rails web application and using D3 map projections.

## Copyright

Copyright 2018 Lauren Nishizaki. All rights reserved.

## Getting started

To get started with the app, clone the repo and then install the needed gems:
```
$ bundle install --without production
```

Migrate the database:
```
$ rails db:migrate
```

Run the test suite to verify that everything is working correctly:
```
$ rails test
```

If the test suite passes, run the app in a local server:
```
$ rails server
```
