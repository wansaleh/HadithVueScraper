'use strict'

exports = ->
  ajaxurl = "http://sunnah.com/ajax"
  lang = 'english'

  _.each ci.codes, (code) ->

    books = require "./data/#{code}/book_titles"

    _.each books, (book) ->
      id = if book.id is "" then "introduction" else book.id

      "#{ajaxurl}/#{lang}/#{code}/#{id}"
