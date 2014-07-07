gulp    = require('gulp')
gutil   = require('gulp-util')
coffee  = require('gulp-coffee')
uglify  = require('gulp-uglify')
header  = require('gulp-header')
concat  = require('gulp-concat')
rename  = require('gulp-rename')
jasmine = require('gulp-jasmine')
pkg     = require('./package.json')

banner = """
/*
	Finch.js - Hierarchical Javascript Routing
	by Rick Allen (stoodder) and Greg Smith (smrq)

	Version #{pkg.version}
	Full source at https://github.com/stoodder/finchjs
	Copyright (c) 2014 RokkinCat, http://www.rokkincat.com

	MIT License, https://github.com/stoodder/finchjs/blob/master/LICENSE.md
*/

"""

paths =
	'coffee': [
		'coffeeV2/*.utility.coffee'
		'coffeeV2/finch.coffee'
		'coffeeV2/finch.error.coffee'
		'coffeeV2/finch.*.coffee'
		'coffeeV2/export.coffee'
	]

	'test_coffee': [
		'tests/tests.coffee'
	]

	'jasmine_helpers': [
		'./tests/sinon-1.7.3.js'
		'./tests/jasmine2.0.0-sinon.js'
	]

	'jasmine': [
		'./tests/tests.js'
	]
#END paths

handleError = (err) ->
	gutil.log(err.toString())
	gutil.log('\u0007') # Make noise
	@emit('end')
#END handleError

gulp.task 'coffee', ->
	gulp.src(paths.coffee)
	    .pipe(concat('finch.coffee'))
	    .pipe(coffee()).on('error', handleError)
	    .pipe(rename('finch.js'))
	    .pipe(header(banner))
	    .pipe(gulp.dest('./'))
	
	    .pipe(uglify()).on('error', handleError)
	    .pipe(rename('finch.min.js'))
	    .pipe(header(banner))
	    .pipe(gulp.dest('./'))
	#END gulp
#END coffee

gulp.task 'test_coffee', ->
	gulp.src(paths.test_coffee)
	    .pipe(concat('tests.coffee'))
	    .pipe(coffee()).on('error', handleError)
	    .pipe(rename('tests.js'))
	    .pipe(gulp.dest('./tests/'))
	#END gulp
#END test_coffee

gulp.task 'jasmine', ->
	gulp.src(paths.jasmine)
		.pipe(concat("_tests.js"))
	    .pipe(jasmine())
	#END gulp
#END jasmine

gulp.task 'watch', ->
	gulp.watch(paths.coffee, ['coffee'])
	gulp.watch(paths.test_coffee, ['test_coffee'])
#END watch

gulp.task 'build', ['coffee', 'test_coffee']
gulp.task 'test', ['jasmine']
gulp.task 'default', ['build', 'watch']