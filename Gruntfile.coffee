module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig
    coffee:
      app:
        expand: true
        cwd: 'src'
        src: ['widget.coffee']
        dest: 'build'
        ext: '.js'
    stylus:
      compile:
        options:
          paths: ['src/stylus/']
          'include css': true
          use: [
            require('nib')
          ]
        files:
          'build/widget.css': 'src/stylus/widget.styl'
    watch:
      js:
        files: '**/*.coffee'
        tasks: ['coffee']
      styl:
        files: '**/*.styl'
        tasks: ['stylus']

  # These plugins provide necessary tasks.
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  # Default task.
  grunt.registerTask 'default', ['coffee']
