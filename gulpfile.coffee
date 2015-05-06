imageoptim = require 'gulp-imagemin'
coffee = require 'gulp-coffee'
sass   = require 'gulp-ruby-sass'
chmod  = require 'gulp-chmod'
prefix = require 'gulp-autoprefixer'
concat = require 'gulp-concat'
gulp   = require 'gulp'
#haml = require 'gulp-haml' # uncomment this line if you want to use haml
#but remember to add gulp-haml to the dependencies in package.json and run npm install


#pretty straight forward, edit as necessary
DIR = 
	JS : 
		IN : 'src/assets/coffee/*.coffee'
		OUT : 'dist/assets/js/'
		VENDOR : 'src/assets/vendor/*.js'
	CSS :
		IN : 'src/assets/sass/app.sass'
		OUT : 'dist/assets/css/'
	IMG : 
		IN : ['src/assets/images/*', 'src/assets/images/*/*']
		OUT : 'dist/assets/images/'
	HTML :
		IN : ['src/views/*.html', 'src/views/*/*.html']
		OUT : 'dist/'


gulp.task 'sass', ->
	sass DIR.CSS.IN, style: 'compressed'
		.pipe prefix "> %1"
		.pipe gulp.dest DIR.CSS.OUT

gulp.task 'coffee', ->
	#your own coffeescript files
	gulp.src DIR.JS.IN
		.pipe coffee bare: true
		.pipe concat "app.js"
		.pipe gulp.dest DIR.JS.OUT

	#vendor files (Angular / React / jQuery etc)
	#this is only if you want to serve these yourself
	#instead of a cdn. Main purpose for this actually
	#only to because I do a lot of development during
	#my communit and I don't have Internet Access all
	#the time so it helps to serve these yourself
	gulp.src DIR.JS.VENDOR
		.pipe concat "vendor.js"
		.pipe chmod 655
		.pipe gulp.dest DIR.JS.OUT

gulp.task 'html', ->
	gulp.src DIR.HTML.IN
		.pipe gulp.dest DIR.HTML.OUT

gulp.task 'images', ->
	gulp.src DIR.IMG.IN
		.pipe chmod 644
		.pipe imageoptim svgoPlugins: [{removeViewBox:false}], progressive: true
		.pipe gulp.dest DIR.IMG.OUT

gulp.task 'watch', ->
	gulp.watch DIR.CSS.IN, ['sass']
	gulp.watch DIR.JS.IN, ['coffee']
	gulp.watch DIR.HTML.IN, ['html']
	gulp.watch DIR.IMG.IN, ['images']

gulp.task 'default', ['sass', 'coffee', 'html', 'images', 'watch']