module.exports = ({refreshEvery, name, logger}, fn) ->
  cached = false
  cachedResults = null
  tid = null
  name ?= fn.name
  throw new Error('refresh rate is required') unless refreshEvery > 0

  refresh = ->
    startAt = Date.now()
    fn (err, results...) ->
      if err?
        logger?.error "Error Refreshing Greedy Memory Cache: #{name} #{err}"
      else
        logger?.info "Greedy Memory Cache Refreshed in #{Date.now() - startAt}ms: #{name}"
      cachedResults = results
      cached = true

      # schedule the next run
      tid = setTimeout(refresh, refreshEvery)

  # call immediately to warm cache
  refresh()

  # wrap function to return cached results when available
  wrapped = (cb) ->
    if cached
      logger?.info "Greedy Memory Cache Hit: #{name}"
      cb(null, cachedResults...)
    else
      fn(cb)

  # add a destroy method for garbage collection and graceful shutdown
  wrapped.destroy = ->
    clearTimeout tid

  process?.on 'SIGTERM', wrapped.destroy
  return wrapped
