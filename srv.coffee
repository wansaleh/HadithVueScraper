'use strict'

express = require 'express'
fs = require 'fs'
path = require 'path'
_ = require 'lodash'
fs = require 'fs'
request = require 'request'
cheerio = require 'cheerio'

datapath = './data'
url = 'http://sunnah.com'

ci = require './data/collection_info'

app = express()

app.get '/', (req, res) ->
  res.send require('./srv/fetchtext')

app.listen 6789, '0.0.0.0', ->
  console.log 'Express server listening on %s:%d', '0.0.0.0', 6789
