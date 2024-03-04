rule('lib_report')
  after_run(function(target)
    for k, v in pairs(target._DEPS) do
      os.execv('lcov', {
        '-o', path.join(target:targetdir(), k .. '.info'),
        '-c', '-d', v:objectdir(),
      })
    end
  end)
rule_end()

