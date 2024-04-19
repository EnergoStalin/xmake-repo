rule('report')
  after_run(function(target)
    os.execv('lcov', {
      '-o', path.join(target:targetdir(), 'coverage.info'),
      '-c', '-d', target:objectdir()
    })
  end)
rule_end()

rule('genhtml')
  after_run(function(target)
    os.execv('genhtml', {
      '-exclude', '/usr/*',
      '-o', path.join(target:rootdir(), 'report'),
      path.join(target:targetdir(), '*.info')
    })
  end)
rule_end()
