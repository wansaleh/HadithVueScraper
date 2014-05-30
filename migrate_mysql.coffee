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

# insertHadithEnglish = (db, hadith) ->
#   db.query "INSERT INTO englishTexts VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
#   [
#     null
#     hadith.collection
#     hadith.volumeNumber
#     bookNum(hadith.bookNumber)
#     hadith.bookID
#     hadith.bookName
#     hadith.babNumber
#     formatter.babName(hadith.babName)
#     hadith.hadithNumber
#     formatter.hadithFormat(hadith.hadithText)
#     hadith.grade1
#     hadith.grade2
#     hadith.ourHadithNumber
#   ]

# insertHadithArab = (db, hadith) ->
#   db.query "INSERT INTO arabicTexts VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
#   [
#     null
#     hadith.collection
#     hadith.volumeNumber
#     bookNum(hadith.bookNumber)
#     hadith.bookID
#     hadith.bookName
#     hadith.babNumber
#     hadith.babName
#     hadith.hadithNumber
#     hadith.hadithText
#     hadith.grade1
#     hadith.grade2
#     hadith.ourHadithNumber
#   ]


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



mysql = require("mysql")
db = mysql.createConnection
  host     : 'localhost'
  user     : 'root'
  password : 'www'
  database : 'IslamVue'

# # UPDATE COLLECTIONID IN HADITHTEXTS
# db.connect()
# codes_normal.forEach (code, i) ->
#   collection_id = i+1
#   collection_code = code
#   # db.query "UPDATE englishTexts SET collection_id = ? WHERE collection_code = ?", [collection_id, collection_code]
#   # db.query "UPDATE arabicTexts SET collection_id = ? WHERE collection_code = ?", [collection_id, collection_code]
#   # db.query "UPDATE books SET collection_id = ? WHERE collection_code = ?", [collection_id, collection_code]
# db.end()


# db.connect()

# codes_normal.forEach (code) ->

#   console.log 'Collection: %s'.blue, code
#   bookInfo = require("./data/#{code}/books")

#   unless _.contains(['nawawi40', 'qudsi40'], code)

#     bar = new ProgressBar ':bar', total: bookInfo.length

#     bookInfo.forEach (book) ->
#       id = bookNum book.id
#       hadithContents = require("./data/#{code}/english/#{id}")
#       hadithContents.forEach (row) ->
#         insertHadithEnglish(db, row)
#       bar.tick()

#   else

#     bar = new ProgressBar ':bar', total: 1
#     hadithContents = require("./data/#{code}/english/1")
#     hadithContents.forEach (row) ->
#       insertHadithEnglish(db, row)
#     bar.tick()

# db.end()

# db.connect()

# codes_normal.forEach (code) ->

#   console.log 'Collection: %s'.blue, code
#   bookInfo = require("./data/#{code}/books")

#   if bookInfo.length > 0

#     bar = new ProgressBar ':bar', total: bookInfo.length

#     bookInfo.forEach (book) ->
#       id = bookNum book.id
#       hadithContents = require("./data/#{code}/arabic/#{id}")
#       hadithContents.forEach (row) ->
#         insertHadithArab(db, row)
#       bar.tick()

#   else

#     bar = new ProgressBar ':bar', total: 1
#     hadithContents = require("./data/#{code}/arabic/1")
#     hadithContents.forEach (row) ->
#       insertHadithArab(db, row)
#     bar.tick()

# db.end()


# db.connect()

# codes_normal.forEach (code) ->
#   c = require("./data/collections")
#   db.query "INSERT INTO collections VALUES (?, ?, ?, ?)",
#   [
#     null
#     code
#     c.titles.english[code]
#     c.titles.arabic[code]
#   ]

# db.end()

# db.connect()

# bookId = (id) ->
#   id = bookNum id
#   book_id = "#{id}.0"
#   book_id = '35.2' if id is '-35'

#   book_id


# codes_normal.forEach (code) ->
#   bookInfo = require("./data/#{code}/books")
#   resBookInfo = []
#   for b in bookInfo
#     db.query "INSERT INTO books VALUES (?, ?, ?, ?, ?, ?)",
#     [
#       null
#       code
#       bookNum(b.id)
#       bookId(b.id)
#       formatter.bookTitle(b.title.english)
#       b.title.arabic
#     ]

# db.end()

