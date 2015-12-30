gulp = require 'gulp'
gutil = require 'gutil'
_ = require 'lodash'

ngAnnotate = require 'gulp-ng-annotate'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
minifyCSS = require 'gulp-cssnano'
htmlReplace = require 'gulp-html-replace'
sourcemaps = require 'gulp-sourcemaps'
less       = require 'gulp-less'

path =
  coffee:
    src: ['app/scripts/app.coffee', './app/scripts/*/*.coffee']
  less:
    src: ['app/less/*.less']
  bower:
    src: [
      'bower_components/lodash/lodash.min.js'
      'bower_components/moment/min/moment.min.js'
      'bower_components/async/dist/async.min.js'
      'bower_components/jquery/dist/jquery.min.js'
      'bower_components/bootstrap/dist/js/bootstrap.min.js'
      'bower_components/bootstrap-select/dist/js/bootstrap-select.min.js'
      'bower_components/angular/angular.min.js'
      'bower_components/angular-filter/dist/angular-filter.min.js'
      'bower_components/angular-resource/angular-resource.min.js'
      'bower_components/angular-ui-router/release/angular-ui-router.min.js'
      'bower_components/angular-sanitize/angular-sanitize.min.js'
    ]
    css: [
      "bower_components/bootstrap/dist/css/bootstrap.min.css"
      "bower_components/font-awesome/css/font-awesome.min.css"
      "css/main.css"
    ]

# develop task

gulp.task 'w-coffee', () ->
  ww = gulp.watch path.coffee.src, ['d-app']
  ww.on 'change', (event) ->
    console.log 'File ' + event.path + ' was ' + event.type + ', running tasks...'

gulp.task 'd-app', () ->
  gulp.src path.coffee.src
    .pipe coffee().on('error', gutil.log)
    .pipe sourcemaps.init()
    .pipe concat 'app.js'
    .pipe sourcemaps.write './'
    .pipe gulp.dest "app/js/"
  gulp.src 'app/scripts/force.coffee'
    .pipe coffee().on('error', gutil.log)
    .pipe gulp.dest "app/js/"

gulp.task 'w-less', () ->
  ww = gulp.watch path.less.src, ['d-css']
  ww.on 'change', (event) ->
    console.log 'File ' + event.path + ' was ' + event.type + ', running tasks...'

gulp.task 'd-css', () ->
  gulp.src path.less.src
    .pipe less()
    .pipe concat 'main.css'
    .pipe gulp.dest 'app/css/'


# build task

gulp.task 'b-app', () ->
  gulp.src path.coffee.src
    .pipe coffee().on('error', gutil.log)
    .pipe ngAnnotate()
    .pipe concat 'app.js'
    .pipe uglify {}
    .pipe gulp.dest './dist/js/'

gulp.task 'b-vendor', () ->
  gulp.src path.bower.src
    .pipe concat 'vendor.js'
    .pipe gulp.dest './dist/js/'

gulp.task 'b-css', () ->
  gulp.src path.bower.css
    .pipe minifyCSS()
    .pipe concat 'style.css'
    .pipe gulp.dest './dist/css/'

gulp.task 'b-copy', () ->
  gulp.src 'bower_components/bootstrap/dist/fonts/*'
    .pipe gulp.dest './dist/fonts/'
  gulp.src 'bower_components/font-awesome/fonts/*'
    .pipe gulp.dest './dist/fonts/'

  gulp.src 'app/img/*'
    .pipe gulp.dest './dist/img/'

  gulp.src 'app/views/**/*.html'
    .pipe gulp.dest './dist/views/'

gulp.task 'b-index', () ->
  opt =
    empty: yes
    spare: yes
    quotes: yes
    conditionals: yes
    comments:yes

  i = Math.round Math.random() * 1000000
  varDic =
    css: "css/style.css?#{i}"
    jsVendor: "js/vendor.js?#{i}"
    jsApp: "js/app.js?#{i}"

  gulp.src './app/index.html'
    .pipe htmlReplace varDic
    .pipe gulp.dest './dist/'

gulp.task 't', ['d-app']

gulp.task 'default', ['d-app', 'w-coffee', 'd-css', 'w-less'], () ->

gulp.task 'd', ['d-app', 'd-css']

gulp.task 'build', ['b-app', 'b-vendor', 'b-css', 'b-index', 'b-copy'], () ->

gulp.task 'b', ['build']

