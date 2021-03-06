var gulp = require("gulp");
var browserify = require("browserify");
var source = require("vinyl-source-stream");
var buffer = require("vinyl-buffer");
var reactify = require("reactify");
var watch = require("gulp-watch");
var plumber = require("gulp-plumber");
var uglify = require('gulp-uglify');

gulp.task("browserify", function() {
  browserify()
    .transform(reactify)
    .require("./src/main.js", {entry: true})
    .bundle()
    .on("error", function(e) { console.log(e.message) })
    .pipe(plumber())
    .pipe(source("app.js"))
    .pipe(buffer())
    .pipe(uglify())
    .pipe(gulp.dest("./public/js"));
});

gulp.task("watch", function() {
  gulp.watch("src/*.js",  ["browserify"]);
  gulp.watch("src/*.jsx", ["browserify"]);
});

gulp.task("default", ["browserify"]);
