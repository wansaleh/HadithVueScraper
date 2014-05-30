fs = require("fs")
_ = require("lodash")
require("colors")
sleep = require('sleep')
ProgressBar = require('progress')
formatter = require './formatter'

Db = require('mongodb').Db
Connection = require('mongodb').Connection
Server = require('mongodb').Server


hadithRepair = (hadith) ->
  res =
    collection: hadith.collection
    volume_number: hadith.volumeNumber
    book_number: hadith.bookNumber
    book_name: hadith.bookName
    bab_number: hadith.babNumber
    bab_name: formatter.babName(hadith.babName)
    hadith_number: hadith.hadithNumber
    hadith_text: formatter.hadithFormat(hadith.hadithText)
    book_id: hadith.bookID
    grade_1: hadith.grade1
    grade_2: hadith.grade2
    hadith_number_edit: hadith.ourHadithNumber



console.log "Connecting to mongodb".yellow
db = new Db('IslamVue', new Server('localhost', 27017, {}), {native_parser:true, safe:true})
db.open (err, db) ->
  # console.log 'opened'.green

  ##################################################
  # COLLECTIONS
  ##################################################
  # db.collection 'hadithCollections', (err, collection) ->
  #   collection.remove {}, (err) ->
  #     hadithCollections = require("./data/collections")

  #     res = []
  #     for code in hadithCollections.codes
  #       bookInfo = require("./data/#{code}/books")
  #       resBookInfo = []
  #       for b in bookInfo
  #         resBookInfo.push
  #           id: if b.id is '' then '0' else b.id
  #           title:
  #             english: formatter.bookTitle(b.title.english)
  #             arabic: b.title.arabic


  #       thisdoc =
  #         code: code
  #         title:
  #           english: hadithCollections.titles.english[code]
  #           arabic: hadithCollections.titles.arabic[code]
  #         books: resBookInfo

  #       collection.insert thisdoc, (err, inserted) ->
  #         db.close()


  ##################################################
  # HADITH TEXT
  ##################################################

  codes_normal = [
    "bukhari"
    "muslim"
    "nasai"
    "abudawud"
    "tirmidhi"
    "ibnmajah"
    "malik"
    "riyadussaliheen"
    "adab"
    "shamail"
    "bulugh"
  ]
  codes_special = [
    "nawawi40"
    "qudsi40"
  ]

  bookId = (id) ->
    id = if id is '' then '-1' else id
    id = if id is '35b' then '-35' else id
    id


  # i = 0

  db.collection 'hadithEnglishTexts', (err, collection) ->
    collection.remove {}, (err) ->

      console.log 'Collection: %s'.blue, code
      bookInfo = require("./data/#{code}/books")

      bar = new ProgressBar ':bar', total: bookInfo.length

      bookInfo.forEach (book) ->
        id = if book.id is '' then '-1' else book.id
        id = if id is '35b' then '-35' else id
        hadithContents = require("./data/#{code}/english/#{id}")
        repaired = _.map hadithContents, hadithRepair

        collection.insert repaired, (err, inserted) ->
          db.close()
          bar.tick()




  # i = 1

  # db.collection 'hadithEnglishTexts', (err, collection) ->
  #   code = codes_special[i]

  #   bar = new ProgressBar ':bar', total: 1
  #   hadithContents = require("./data/#{code}/english/1")
  #   repaired = _.map hadithContents, hadithRepair

  #   collection.insert repaired, (err, inserted) ->
  #     db.close()

  #   bar.tick()





  # db.collection 'hadithEnglishTexts', (err, collection) ->
  #   hadithContents = require("./data/nawawi40/english/1")
  #   repaired = _.map hadithContents, hadithRepair
  #   collection.insert(repaired, (err, inserted) -> db.close())

  #   hadithContents = require("./data/qudsi40/english/1")
  #   repaired = _.map hadithContents, hadithRepair
  #   collection.insert(repaired, (err, inserted) -> db.close())

