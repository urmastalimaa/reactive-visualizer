generateBrowserifyConf = ({minify, map, watch} = {}) ->
  options = {}
  files =
    'public/assets/application.js': [
      'assets/javascripts/**/*.cjsx'
      'assets/javascripts/**/*.coffee'
    ]

  options =
    transform: ['coffee-reactify', 'brfs']
    browserifyOptions:
      extensions: ['.coffee']
    preBundleCB: (b) ->
      if map || minify
        b.plugin('minifyify', map: map || false, minify: minify || false)
      return b
    exclude: ['jquery']

  if watch
    options.watchifyOptions =
      livereload: true
    options.watch = true
    options.keepAlive = true

  {files, options}

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    sass:
      dist:
        files:
          'public/assets/visualizer.css': 'assets/stylesheets/visualizer.sass'

    concat:
      css:
        src: [
          'public/assets/visualizer.css'
          'node_modules/bootstrap/dist/css/bootstrap.css'
          'node_modules/bootstrap-slider/dist/css/bootstrap-slider.css'
        ]
        dest: 'public/assets/application.css'
      dist_html:
        src: [
          'assets/html/intro.html'
          'assets/html/dist_head.html'
          'assets/html/content_body.html'
          'assets/html/outro.html'
        ]
        dest: 'public/index.html'
      dev_html:
        src: [
          'assets/html/intro.html'
          'assets/html/dev_head.html'
          'assets/html/content_body.html'
          'assets/html/outro.html'
        ]
        dest: 'public/index.html'

    browserify:
      dist: generateBrowserifyConf(minify: true, map: false)
      dev: generateBrowserifyConf()
      dev_watch: generateBrowserifyConf(watch: true)

    concurrent:
      options:
        logConcurrentOutput: true
      dev:
        tasks: ["watch", "browserify:dev_watch"]
    watch:
      sass:
        files: ['assets/stylesheets/**/*.sass']
        tasks: ['sass', 'concat:css']
      app:
        files: ['public/assets/application.js', 'public/index.html', 'public/assets/application.css']
        tasks: []
        options:
          livereload: true
    'http-server':
      dev:
        root: 'public'
        port: 3700
        cache: -1
        runInBackground: true
      dist:
        root: 'public'
        port: 3700
        cache: 60
        runInBackground: false

  grunt.loadNpmTasks 'grunt-concurrent'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-http-server'
  grunt.loadNpmTasks 'grunt-browserify'


  grunt.registerTask 'dist', ['sass', 'concat:dist_html', 'concat:css', 'browserify:dist']
  grunt.registerTask 'dev', ['sass', 'concat:dev_html', 'concat:css', 'browserify:dev']
  grunt.registerTask 'dev_watch', ['sass', 'concat:dev_html', 'concat:css', 'http-server:dev', 'concurrent:dev']

  grunt.registerTask 'default', ['dist', 'http-server:dist']
