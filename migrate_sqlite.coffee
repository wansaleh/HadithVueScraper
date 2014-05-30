fs = require("fs")
_ = require("lodash")
require("colors")
sleep = require('sleep')
ProgressBar = require('progress')
formatter = require './formatter'


bookNum = (id) ->
  id = if id is '' then '-1' else id
  id = if id is '35b' then '-35' else id
  id

insertHadithEnglish = (hadith) ->
  stmt = db.prepare("INSERT INTO hadithEnglishTexts VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")
  stmt.run null,
    hadith.collection,
    hadith.volumeNumber,
    bookNum(hadith.bookNumber),
    hadith.bookName,
    hadith.babNumber,
    formatter.babName(hadith.babName),
    hadith.hadithNumber,
    formatter.hadithFormat(hadith.hadithText),
    hadith.bookID,
    hadith.grade1,
    hadith.grade2,
    hadith.ourHadithNumber
  stmt.finalize()
insertHadithArab = (hadith) ->
  stmt = db.prepare("INSERT INTO hadithArabicTexts VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")
  stmt.run null,
    hadith.collection,
    hadith.volumeNumber,
    bookNum(hadith.bookNumber),
    hadith.bookName,
    hadith.babNumber,
    hadith.babName,
    hadith.hadithNumber,
    hadith.hadithText,
    hadith.bookID,
    hadith.grade1,
    hadith.grade2,
    hadith.ourHadithNumber
  stmt.finalize()


codes_normal = [
  "bukhari",
  "muslim",
  "nasai",
  "abudawud",
  "tirmidhi",
  "ibnmajah",
  "malik",
  "nawawi40",
  "riyadussaliheen",
  "adab",
  "qudsi40",
  "shamail",
  "bulugh"
]



sqlite3 = require("sqlite3").verbose()
db = new sqlite3.Database("IslamVue.db")

db.serialize ->

  codes_normal.forEach (code) ->

    console.log 'Collection: %s'.blue, code
    bookInfo = require("./data/#{code}/books")

    if bookInfo.length > 0

      bar = new ProgressBar ':bar', total: bookInfo.length

      bookInfo.forEach (book) ->
        id = bookNum book.id
        hadithContents = require("./data/#{code}/english/#{id}")
        hadithContents.forEach (row) ->
          insertHadithEnglish(row)
        bar.tick()

    else

      bar = new ProgressBar ':bar', total: 1
      hadithContents = require("./data/#{code}/english/1")
      hadithContents.forEach (row) ->
        insertHadithEnglish(row)
      bar.tick()

  return

db.close()

# db.serialize ->

#   codes_normal.forEach (code) ->

#     console.log 'Collection: %s'.blue, code
#     bookInfo = require("./data/#{code}/books")

#     if bookInfo.length > 0

#       bar = new ProgressBar ':bar', total: bookInfo.length

#       bookInfo.forEach (book) ->
#         id = bookNum book.id
#         hadithContents = require("./data/#{code}/arabic/#{id}")
#         hadithContents.forEach (row) ->
#           insertHadithArab(row)
#         bar.tick()

#     else

#       bar = new ProgressBar ':bar', total: 1
#       hadithContents = require("./data/#{code}/arabic/1")
#       hadithContents.forEach (row) ->
#         insertHadithArab(row,)
#       bar.tick()

#   return

# db.close()


# db.serialize ->

#   codes_normal.forEach (code) ->
#     c = require("./data/collections")
#     stmt = db.prepare("INSERT INTO collections VALUES (?, ?, ?, ?)")
#     stmt.run null,
#       code
#       c.titles.english[code]
#       c.titles.arabic[code]
#     stmt.finalize()
#   return

# db.close()

# db.serialize ->

#   codes_normal.forEach (code) ->
#     bookInfo = require("./data/#{code}/books")
#     resBookInfo = []
#     for b in bookInfo
#       stmt = db.prepare("INSERT INTO books VALUES (?, ?, ?, ?, ?)")
#       stmt.run null,
#         code
#         bookNum(b.id)
#         formatter.bookTitle(b.title.english)
#         b.title.arabic
#       stmt.finalize()
#   return

# db.close()

