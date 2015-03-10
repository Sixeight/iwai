var gulp = require("gulp");
var browserify = require("browserify");
var source = require("vinyl-source-stream");
var buffer = require("vinyl-buffer");
var reactify = require("reactify");
var watch = require("gulp-watch");
var plumber = require("gulp-plumber");
var uglify = require('gulp-uglify');

gulp.task("browserify", function() {
  var bs = browserify({
    entries: ["./src/main.js"],
    transform: [reactify]
  });
  return gulp
    .src("./src/main.js", {"read": false})
    .pipe(plumber())
    .pipe(bs.bundle())
    .pipe(source("app.js"))
    .pipe(buffer())
    .pipe(uglify())
    .pipe(gulp.dest("./public/js"));
});

gulp.task("watch", function() {
  gulp.watch("src/*.js",  ["browserify"]);
  gulp.watch("src/*.jsx", ["browserify"]);
});

gulp.task('compress', function() {
  gulp.src('lib/*.js')
    .pipe(uglify())
    .pipe(gulp.dest('dist'))
});

gulp.task("default", ["browserify"]);
