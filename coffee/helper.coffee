fs = require 'fs'
webpage = require 'webpage'

module.exports =
  Scraper: class
    constructor: (@csv_path, @url, @selector, @headers, @convert = (data) -> data) ->
      @page = webpage.create()
      @data = []
    run: (callback) -> @page.open @url, =>
      @load()
      @output()
      callback()
    load: ->
      arg = selector: @selector
      @data = @convert @page.evaluate (arg) =>
        $(cell).text().trim() for cell in $(row).children() for row in $(arg.selector).children()
      , arg
    output: ->
      # CSVデータの作成
      console.log @headers.join(',')
      console.log row.join(',') for row in @data