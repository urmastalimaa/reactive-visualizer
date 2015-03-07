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
          'public/assets/application.css': 'assets/stylesheets/application.sass'
    cjsx:
      compile:
        files:
          'public/assets/analyzer.js': [
            'assets/javascripts/app.coffee'
            'assets/javascripts/react_nodes/*.coffee'
            'assets/javascripts/evaluator/*.coffee'
            'assets/javascripts/factory/*.coffee'
            'assets/javascripts/simulator/*.coffee'
            'assets/javascripts/result_displayer/*.coffee'
          ]

    concat:
      dist:
        src: [
          'bower_components/rxjs/dist/rx.all.js'
          'bower_components/rxjs/dist/rx.testing.js'
          'bower_components/jquery/dist/jquery.js'
          'node_modules/ramda/dist/ramda.js'
          'node_modules/react/dist/react.js'
          'public/assets/analyzer.js'
        ]
        dest: 'public/assets/application.js'
    slim:
      dist:
        files: [
          expand: true
          cwd: 'templates'
          src: ['{,*/}*.slim']
          dest: 'public'
          ext: '.html'
        ]
    watch:
      sass:
        files: ['assets/stylesheets/**/*.sass']
        tasks: ['sass']
      coffee:
        files: ['assets/javascripts/**/*.coffee']
        tasks: ['cjsx', 'concat']
      slim:
        files: ['templates/**/*.slim']
        tasks: ['slim']
      deps:
        files: ['bower_components/rxjs/dist/rx.all.js']
        tasks: ['concat']

    'http-server':
      dev:
        root: 'public'
        port: 3700
        cache: -1
        runInBackground: true

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-slim'
  grunt.loadNpmTasks 'grunt-http-server'
  grunt.loadNpmTasks 'grunt-coffee-react'

  grunt.registerTask 'default', ['sass', 'cjsx', 'slim', 'concat']
  grunt.registerTask 'run', ['default', 'http-server:dev', 'watch']
