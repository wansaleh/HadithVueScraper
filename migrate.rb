# encoding: UTF-8

require 'json'
require 'pp'
require 'term/ansicolor'

require 'sequel'

class String
  include Term::ANSIColor
end

puts "Opening connection".yellow

# connect to an in-memory database
DB = Sequel.sqlite('IslamVue.db')

# create a dataset from the items table
items = DB[:test2]

# populate the table
items.insert(:volume_number => '1654564')


# json = File.read('./data/collections.json').force_encoding("UTF-8")
# obj = JSON.parse(json)

# # pp obj

# newObj = {}

# obj["codes"].each do |val|
#   puts val
# end

