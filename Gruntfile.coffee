module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    sass:
      options:
        loadPath: [
          'bower_components/bourbon/dist/'
        ]
      dist:
        files:
          'public/assets/visualizer.css': 'assets/stylesheets/visualizer.sass'
    concat:
      css:
        src: [
          'public/assets/visualizer.css'
          'bower_components/bootstrap/dist/css/bootstrap.css'
          'bower_components/bootstrap-slider/slider.css'
        ]
        dest: 'public/assets/application.css'
    browserify:
      dist:
        files:
          'public/assets/application.js': [
            'assets/javascripts/**/*.cjsx'
            'assets/javascripts/**/*.coffee'
          ]
        options:
          transform: ['coffee-reactify']
          browserifyOptions:
            extensions: ['.coffee']
      dev_watch:
        files:
          'public/assets/application.js': [
            'assets/javascripts/**/*.cjsx'
            'assets/javascripts/**/*.coffee'
          ]
        options:
          transform: ['coffee-reactify']
          browserifyOptions:
            extensions: ['.coffee']
          watchifyOptions:
            livereload: true
          watch: true
          keepAlive: true
    slim:
      dist:
        files:
          'public/index.html': 'templates/index.slim'
      dev:
        files:
          'public/index.html': 'templates/index_dev.slim'
    concurrent:
      options:
        logConcurrentOutput: true
      dev:
        tasks: ["watch", "browserify:dev_watch"]

    watch:
      sass:
        files: ['assets/stylesheets/**/*.sass']
        tasks: ['sass', 'concat:css']
      slim:
        files: ['templates/**/*.slim']
        tasks: ['slim:dev']
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

  grunt.loadNpmTasks 'grunt-concurrent'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-slim'
  grunt.loadNpmTasks 'grunt-http-server'
  grunt.loadNpmTasks 'grunt-coffee-react'
  grunt.loadNpmTasks 'grunt-browserify'


  grunt.registerTask 'default', ['sass', 'slim:dist', 'concat', 'browserify:dist']
  grunt.registerTask 'run', ['sass', 'slim:dev', 'concat', 'http-server:dev', 'concurrent:dev']
