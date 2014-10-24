// Generated by CoffeeScript 1.8.0
(function() {
  var __slice = [].slice;

  module.exports = function(_arg, fn) {
    var cached, cachedResults, logger, name, refresh, refreshEvery, tid, wrapped;
    refreshEvery = _arg.refreshEvery, name = _arg.name, logger = _arg.logger;
    cached = false;
    cachedResults = null;
    tid = null;
    if (name == null) {
      name = fn.name;
    }
    if (!(refreshEvery > 0)) {
      throw new Error('refresh rate is required');
    }
    refresh = function() {
      var startAt;
      startAt = Date.now();
      return fn(function() {
        var err, results;
        err = arguments[0], results = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        if (err != null) {
          if (logger != null) {
            logger.error("Error Refreshing Greedy Memory Cache: " + name + " " + err);
          }
        } else {
          if (logger != null) {
            logger.info("Greedy Memory Cache Refreshed in " + (Date.now() - startAt) + "ms: " + name);
          }
        }
        cachedResults = results;
        cached = true;
        return tid = setTimeout(refresh, refreshEvery);
      });
    };
    refresh();
    wrapped = function(cb) {
      if (cached) {
        if (logger != null) {
          logger.info("Greedy Memory Cache Hit: " + name);
        }
        return cb.apply(null, [null].concat(__slice.call(cachedResults)));
      } else {
        return fn(cb);
      }
    };
    wrapped.destroy = function() {
      return clearTimeout(tid);
    };
    if (typeof process !== "undefined" && process !== null) {
      process.on('SIGTERM', wrapped.destroy);
    }
    return wrapped;
  };

}).call(this);