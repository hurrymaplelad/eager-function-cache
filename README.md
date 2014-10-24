eager-function-cache
==============

Call a slow function on a fixed schedule, returning the latest result

[![NPM version](http://img.shields.io/npm/v/eager-function-cache.svg?style=flat-square)](https://www.npmjs.org/package/eager-function-cache)
[![Build Status](http://img.shields.io/travis/hurrymaplelad/eager-function-cache/master.svg?style=flat-square)](https://travis-ci.org/hurrymaplelad/eager-function-cache)

``` coffee
cache = require 'eager-function-cache'
{duration} = require 'moment'

cachedFn = cache refreshEvery: duration(10, 'minutes'), (done) ->
  # slow stuff here
  done(err, result)
```
