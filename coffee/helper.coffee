fs = require 'fs'
webpage = require 'webpage'

module.exports =
  Scraper: class
    constructor: (@csv_path, @url, @selector, @headers, @convert = (data) -> data) ->
      @page = webpage.create()
      @data = []
    run: (callback) -> @page.open @url, =>
      @load()
      @save()
      callback()
    load: ->
      arg = selector: @selector
      @data = @convert @page.evaluate (arg) =>
        $(cell).text().trim() for cell in $(row).children() for row in $(arg.selector).children()
      , arg
    save: ->
      # CSVデータの作成
      csv = @headers.join(',') + '\n'
      csv += row.join(',') + '\n' for row in @data
      
      # ファイルに保存
      file = fs.open @csv_path, 'w'
      file.write csv.trim()
      file.close()
      console.log "exported: #{@csv_path}"