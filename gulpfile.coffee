spawn = require('child_process').spawn
gulp = require 'gulp'
gutil = require 'gulp-util'

load_from_bower_components = ->
  gulp.src [
    './bower_components/jquery/dist/jquery.min.js'
    './bower_components/bootstrap/dist/js/bootstrap.min.js'
    './bower_components/respond/dest/respond.min.js'
    './bower_components/add-to-homescreen/src/add2home.js'
  ]
  .pipe gulp.dest './js/'
  gulp.src [
    './bower_components/bootstrap/dist/css/bootstrap.min.css'
    './bower_components/add-to-homescreen/style/add2home.css'
  ]
  .pipe gulp.dest './css/'
  gulp.src [
    './bower_components/bootstrap/dist/fonts/*'
  ]
  .pipe gulp.dest './fonts/'

gulp.task 'bower:install', ->
  bower = spawn 'bower', ['install']
  bower.stdout.on 'close', (code) -> load_from_bower_components()

gulp.task 'bower:update', ->
  bower = spawn 'bower', ['update']
  bower.stdout.on 'close', (code) -> load_from_bower_components()

gulp.task 'scrape', ->
  phantom = spawn 'phantomjs', ['coffee/scrape.coffee']
  phantom.stdout.on 'data', (data) ->
    gutil.log 'PhantomJS:', data.toString().slice(0, -1)
  phantom.stdout.on 'close', (code) ->
    gutil.log 'Scraping done!' if code == 0

gulp.task 'test', ->
  #TODO: write tests!
