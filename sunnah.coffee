'use strict'

fs = require 'fs'
path = require 'path'
_ = require 'lodash'
fs = require 'fs'
request = require 'request'
cheerio = require 'cheerio'
require 'colors'

datapath = './data'
url = 'http://sunnah.com'


# ###
# 1: Collection Info
# ###

# fs.exists datapath, (exists) -> fs.mkdir(datapath) if not exists

# request url, (error, response, html) ->
#   if not error
#     $ = cheerio.load html

#     collection_info =
#       codes: []
#       titles:
#         english: {}
#         arabic: {}

#     $('.collections .collection_titles .collection_title').each (i, el) ->
#       link = $(this).find('a').attr('href').trim()
#       code = link.substring(1).trim()
#       collection_info.codes.push code
#       collection_info.titles.english[code] = $(this).find('.english_collection_title').text().trim()
#       collection_info.titles.arabic[code] = $(this).find('.arabic_collection_title').text().trim()

#     json = JSON.stringify collection_info, null, "  "

#     file = "#{datapath}/collections.json"
#     fs.writeFile file, json, (args) ->
#       console.log "Saved: #{file}"





ci = require "#{datapath}/collections"

# ###
# 2. Collection - Books
# ###

# _.each ci.codes, (code) ->
#   request "#{url}/#{code}", (error, response, html) ->
#     if not error
#       $ = cheerio.load html

#       book_titles = []
#       $('.book_titles > .book_title').each ->
#         book_titles.push
#           id: $(this).find('.book_number').text().trim()
#           title:
#             english: $(this).find('.english_book_name').text()
#             arabic:  $(this).find('.arabic_book_name').text()

#       json = JSON.stringify book_titles, null, "  "

#       path = "#{datapath}/#{code}/books.json"

#       fs.mkdir "#{datapath}/#{code}", ->
#         fs.writeFile path, json, (args) -> console.log "Saved: #{path}"







# ###
# Collection details
# ###

# url = 'http://sunnah.com/ajax/english'
# collection = 'bukhari'
# book =

# request "#{url}/#{collection}/#{book}", (error, response, html) ->
#   console.error error if error
#   if not error
#     console.log JSON.parse(html)

#     # bukhari = {}

#     # $ = cheerio.load html
#     # $('.collection_info').each ->
#     #   colindex = $(this).find('.colindextitle')

#     #   bukhari.title =
#     #     english: colindex.eq(0).children('div').eq(1).html().trim()
#     #     arabic:  colindex.eq(0).children('div').eq(0).html().trim()

#     #   bukhari.details = colindex.eq(1).html().trim()

#     # console.log bukhari








# # # ###
# # # 3. Book content
# # # ###

# ajaxurl = "http://sunnah.com/ajax"
# langs = ['english', 'arabic', 'indonesian']

# _.each ci.codes, (code) ->

#   books = require "./data/#{code}/books"

#   _.each books, (book) ->
#     id = if book.id is "" then "-1" else book.id

#     # if isNaN id
#     #   id = '' + (-parseInt(id))
#     #   console.log "Wierd book ID: #{code}/#{id}. Changed to: #{-parseInt(id)}".red

#     _.each langs, (lang) ->

#       path = "#{datapath}/#{code}/#{lang}"
#       filename = "#{path}/#{id}.json"

#       if fs.existsSync filename
#         console.log "#{filename} already exist! Skipping...".yellow

#       else

#         if !fs.existsSync(path)
#           console.log "Path #{path} doesn't exist, creating it.".blue
#           fs.mkdir path

#         request "#{ajaxurl}/#{lang}/#{code}/#{id}", (error, response, html) ->
#           if error or html.match(/^\n<h2>Error/)? or !String(html).trim().length
#             console.log "Error: #{ajaxurl}/#{lang}/#{code}/#{id}".red

#           else
#             console.log "Requested: #{ajaxurl}/#{lang}/#{code}/#{id}".grey
#             json = JSON.stringify JSON.parse(html), null, "  "

#             fs.writeFile filename, json, (err) ->
#               if err
#                 console.log err.red
#               else
#                 console.log "Saved: #{filename}".green


# # specials: qudsi40 & nawawi40
# _.each ['nawawi40', 'qudsi40'], (code) ->
#   _.each langs, (lang) ->
#     id = "1"

#     path = "#{datapath}/#{code}/#{lang}"
#     filename = "#{path}/#{id}.json"

#     if fs.existsSync filename
#       console.log "#{filename} already exist! Skipping...".yellow

#     else

#       if !fs.existsSync(path)
#         console.log "Path #{path} doesn't exist, creating it.".blue
#         fs.mkdir path

#       request "#{ajaxurl}/#{lang}/#{code}/1", (error, response, html) ->
#         if error or html.match(/^\n<h2>Error/)? or !String(html).trim().length
#           console.log "Error: #{ajaxurl}/#{lang}/#{code}/#{id}".red

#         else
#           console.log "Requested: #{ajaxurl}/#{lang}/#{code}/1"
#           json = JSON.stringify JSON.parse(html), null, "  "

#           path = "#{datapath}/#{code}/#{lang}"
#           filename = "#{path}/1.json"

#           fs.writeFile filename, json, (err) ->
#             if err
#               console.log err.red
#             else
#               console.log "Saved: #{filename}".green
