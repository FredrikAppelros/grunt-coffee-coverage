fs                     = require "fs"
path                   = require "path"
{CoverageInstrumentor} = require "coffee-coverage"

module.exports = (grunt) ->
  grunt.registerMultiTask "coffeeCoverage", ->
    options = @options()
    coverageInstrumentor = new CoverageInstrumentor options

    instrument = =>
      for files in @files
        for file in files.src
          result = coverageInstrumentor.instrument file, files.dest, options
          grunt.log.writeln "Annotated #{result.lines} lines."

    if options.initfile?
      done = @async()

      grunt.file.mkdir path.dirname options.initfile
      options.initFileStream = fs.createWriteStream options.initfile

      options.initFileStream.on "open", ->
        instrument()
        options.initFileStream.end done

    else instrument()
