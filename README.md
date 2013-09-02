sinatra-twitterproxy
====================

A Sinatra-based proxy service for https://github.com/seaofclouds/tweet


## Overview/Notes

A work in progress.  So far 2/4 of the sea of clouds API calls are handled by the proxy:

  * /1.1/statuses/user_timeline.json
  * /1.1/search/tweets.json

Remaining:

  * /1.1/lists/statuses.json
  * /1.1/favorites/list.json


The first two were easy to implement on top of http://sferik.github.io/twitter/, a ruby twitter gem.
The others might require a bit of digging around.

