cache = require '..'
chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'
{expect} = chai
{duration} = require 'moment'

describe 'cache', ->
  {fn, cachedFn} = {}
  beforeEach ->
    fn = sinon.spy (cb) -> cb null, 42
    cachedFn = cache refreshEvery: 100, fn

  afterEach ->
    cachedFn.destroy()

  it 'calls the function immeadiately', ->
    expect(fn).to.have.been.called

  it 'caches an async function result', (done) ->
    cachedFn (err, result) ->
      expect(result).to.eql 42
      expect(fn.callCount).to.eql 1
      cachedFn (err, result) ->
        expect(result).to.eql 42
        expect(fn.callCount).to.eql 1
        done()

  it 're-evaluates the function after a fixed delay', (done) ->
    setTimeout ->
      expect(fn.callCount).to.eql 2
      done()
    , 150

  describe 'given a slow function to cache', ->
    {slowFn, cachedSlowFn} = {}
    beforeEach ->
      callbacks = []
      slowFn = sinon.spy (cb) -> callbacks.push cb
      cachedSlowFn = cache refreshEvery: duration(10, 'minutes'), slowFn

    afterEach ->
      cachedSlowFn.destroy()

    describe 'calling the cached function before the cache is warmed', ->
      beforeEach ->
        cachedSlowFn ->

      it 'calls through to the original function', ->
        expect(slowFn.callCount).to.eql 2
