# *****************
#    DEFINE-VARS
# *****************
_ = require "underscore"
gulp = require "gulp"
coffee = require "gulp-coffee"
coffeelint = require "gulp-coffeelint"
exec = require("child_process").exec
mocha = require "gulp-mocha"
mocha_phantomjs = require "gulp-mocha-phantomjs"
qunit = require "gulp-qunit"
sourcemaps = require "gulp-sourcemaps"


# ******************
#    CONCAT-TASKS
# ******************
gulp.task "default", ["test", "build"]
gulp.task "test", [
    "test-backbone"
    "test-backbone-extend"
    "test-own"
]
gulp.task "build", ["lint", "compile"]


# **********
#    TEST
# **********
gulp.task "test-backbone", ->
    gulp
    .src "backbone-test/index.html"
    .pipe qunit()

gulp.task "test-backbone-extend-pre", ->
    gulp
    .src "backbone-test/model.coffee"
    .pipe coffee()
    .pipe gulp.dest "tmp/"

gulp.task "test-backbone-extend", ["test-backbone-extend-pre"], (cb)->
    exec "node tmp/model.js", (err, stdout, stderr)->
        console.log stdout
        console.log stderr
        cb err

gulp.task "test-own-crossbar", (cb)->
    exec "crossbar start &"
    _.delay cb, 10000

gulp.task "test-own", ["test-own-crossbar"], (cb)->
    cb()


# ***********
#    BUILD
# ***********
gulp.task "lint", ->
    gulp.src ["*.coffee", "test/*.coffee"]
    .pipe coffeelint()
    .pipe coffeelint.reporter()
    
gulp.task "compile", ->
    gulp.src "backbone.wamp.coffee"
    .pipe sourcemaps.init()
    .pipe coffee()
    .pipe sourcemaps.write
        includeContent : false
        sourceRoot     : "./"
    .pipe gulp.dest "./"


# *********
#    DEV
# *********
gulp.task "dev", ->
    gulp.watch ["*.coffee"], ["build"]