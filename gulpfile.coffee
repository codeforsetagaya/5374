bower = require 'bower'
gulp = require 'gulp'
gutil = require 'gulp-util'
phantom = require 'gulp-phantom'

load_from_bower_components = ->
  gulp.src [
    './bower_components/jquery/dist/jquery.min.*'
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
  gutil.log 'All bower components loaded.'

gulp.task 'init', ->
  bower.commands.install()
  .on 'log', (r) -> gutil.log r.message if r.level == 'action'
  .on 'end', (r) -> load_from_bower_components()

gulp.task 'update', ->
  bower.commands.update()
  .on 'log', (r) -> gutil.log r.message if r.level == 'action'
  .on 'end', (r) -> load_from_bower_components()
  
gulp.task 'phantom', ->
  gulp.src ['./phantom/*.coffee']
  .pipe phantom ext: '.csv', trim: true
  .pipe gulp.dest './data/'

gulp.task 'test', ->
  #TODO: write tests!
