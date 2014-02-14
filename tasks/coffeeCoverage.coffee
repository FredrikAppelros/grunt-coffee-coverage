fs                     = require "fs"
path                   = require "path"
{CoverageInstrumentor} = require "coffee-coverage"

module.exports = (grunt) ->
    grunt.registerMultiTask "coffeeCoverage", ->
        options = @options()
        instrumentor = new CoverageInstrumentor options

        instrument = =>
            for files in @files
                for file in files.src
                    result = instrumentor.instrument file, files.dest, options
                    grunt.log.writeln "Annotated #{result.lines} lines."

        if options.initFile?
            done = @async()

            grunt.file.mkdir path.dirname options.initFile
            options.initFileStream = fs.createWriteStream options.initFile

            options.initFileStream.on "open", ->
                instrument()
                options.initFileStream.end done

        else instrument()
