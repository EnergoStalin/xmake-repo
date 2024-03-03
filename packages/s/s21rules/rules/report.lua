rule('report')
  after_run(function(target)
    os.execv('lcov', {
      '-o', path.join(target:targetdir(), 'coverage.info'),
      '-c', '-d', target:objectdir()
    })
  end)
rule_end()
