footrest
========

A nice place to rest your feet when building a RESTful API

summary
=======

Configures Faraday to work in a way that is optimal for Canvas and potentially
other RESTful APIs.

Requests will:
  - use multipart for POST and PUT
  - be url encoded
  - be logged
  - follow redirects
  - parse json when content_type says to
  - raise errors on various status codes
  - use a "Bearer" authentication token

license: MIT