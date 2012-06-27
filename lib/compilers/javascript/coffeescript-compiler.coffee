AbstractJavascriptCompiler = require './javascript-compiler'
coffeelint = require 'coffeelint'
logger = require '../../util/logger'

module.exports = class AbstractCoffeeScriptCompiler extends AbstractJavascriptCompiler

  constructor: (config) ->
    super(config)
    @lintOptions = config.coffeelint

  beforeCompile: (source, fileName) ->
    @coffeeLint(source, fileName) if @config.metalint

  coffeeLint: (source, fileName) ->
    try
      lintResults = coffeelint.lint(source, @lintOptions)
    catch err
      return # is an error in compilation of coffeescript, compiler will take care of that

    for result in lintResults
      switch result.level
        when 'error' then @logLint(@coffeeDialect, result, 'Error',   logger.warn, fileName)
        when 'warn'  then @logLint(@coffeeDialect, result, 'Warning', logger.info, fileName)