fs = require("fs")
_ = require("lodash")
require("colors")
sleep = require('sleep')
ProgressBar = require('progress')
formatter = require './formatter'

Db = require('mongodb').Db
Connection = require('mongodb').Connection
Server = require('mongodb').Server

Sequelize = require 'sequelize'
sequelize = new Sequelize 'mysql://root:www@localhost:3306/IslamVue'

mysql =
  Collection: sequelize.define 'collection',
    code: Sequelize.STRING
    title_en: Sequelize.STRING
    title_ar: Sequelize.STRING
  ,
    timestamps: false,
    underscored: true

  Book: sequelize.define 'book',
    collection_id: Sequelize.INTEGER
    collection_code: Sequelize.STRING
    book_number: Sequelize.INTEGER
    book_id: Sequelize.FLOAT
    title_en: Sequelize.TEXT
    title_ar: Sequelize.TEXT
  ,
    timestamps: false,
    underscored: true

  HadithEnglish: sequelize.define 'englishText',
    collection_id: Sequelize.INTEGER
    collection_code: Sequelize.STRING
    volume_number: Sequelize.INTEGER
    book_number: Sequelize.INTEGER
    book_id: Sequelize.STRING
    book_name: Sequelize.TEXT
    bab_number: Sequelize.INTEGER
    bab_name: Sequelize.TEXT
    hadith_number: Sequelize.INTEGER
    hadith_text: Sequelize.TEXT
    grade_1: Sequelize.TEXT
    grade_2: Sequelize.TEXT
    hadith_number_edit: Sequelize.INTEGER
  ,
    timestamps: false,
    underscored: true

  HadithArabic: sequelize.define 'arabicText',
    collection_id: Sequelize.INTEGER
    collection_code: Sequelize.STRING
    volume_number: Sequelize.INTEGER
    book_number: Sequelize.INTEGER
    book_id: Sequelize.INTEGER
    book_name: Sequelize.TEXT
    bab_number: Sequelize.INTEGER
    bab_name: Sequelize.TEXT
    hadith_number: Sequelize.INTEGER
    hadith_text: Sequelize.TEXT
    grade_1: Sequelize.TEXT
    grade_2: Sequelize.TEXT
    hadith_number_edit: Sequelize.INTEGER
  ,
    timestamps: false,
    underscored: true

mysql.Collection.hasMany mysql.HadithEnglish
mysql.HadithEnglish.belongsTo mysql.Collection, foreignKey: 'collection_id'


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
db = new Db('HadithVue', new Server('localhost', 27017, {}), {native_parser:true, safe:true})
db.open (err, db) ->
  # console.log 'opened'.green

  ##################################################
  # COLLECTIONS
  ##################################################
  db.collection 'hadithCollections', (err, collection) ->
    collection.remove {}, (err) ->

      mysql.Collection.findAll()
      .success (data) ->
        data.forEach (row) ->

          mysql.HadithEnglish.findAll
            attributes: ['collection_code', 'book_number', 'book_id', 'book_name']
            where: collection_code: row.dataValues.code
            group: 'collection_id, book_id'
            order: 'book_id ASC'
          .success (books_data) ->
            resBookInfo = []
            books_data.forEach (books_row) ->
              resBookInfo.push
                book_id: books_row.dataValues.book_id
                book_number: books_row.dataValues.book_id
                book_name: books_row.dataValues.book_name

            thisdoc =
              code: row.dataValues.code
              title_en: row.dataValues.title_en
              title_ar: row.dataValues.title_ar
              books: resBookInfo

            console.log "#{row.dataValues.code}".green


            collection.insert thisdoc, (err, inserted) ->
              db.close()




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

  # codes_normal = [
  #   "bukhari"
  #   "muslim"
  #   "nasai"
  #   "abudawud"
  #   "tirmidhi"
  #   "ibnmajah"
  #   "malik"
  #   "riyadussaliheen"
  #   "adab"
  #   "shamail"
  #   "bulugh"
  # ]
  # codes_special = [
  #   "nawawi40"
  #   "qudsi40"
  # ]

  # bookId = (id) ->
  #   id = if id is '' then '-1' else id
  #   id = if id is '35b' then '-35' else id
  #   id


  # # i = 0

  # db.collection 'hadithEnglishTexts', (err, collection) ->
  #   collection.remove {}, (err) ->

  #     console.log 'Collection: %s'.blue, code
  #     bookInfo = require("./data/#{code}/books")

  #     bar = new ProgressBar ':bar', total: bookInfo.length

  #     bookInfo.forEach (book) ->
  #       id = if book.id is '' then '-1' else book.id
  #       id = if id is '35b' then '-35' else id
  #       hadithContents = require("./data/#{code}/english/#{id}")
  #       repaired = _.map hadithContents, hadithRepair

  #       collection.insert repaired, (err, inserted) ->
  #         db.close()
  #         bar.tick()




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

