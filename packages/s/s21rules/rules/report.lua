rule('report')
  if not is_mode('coverage') then return end

  after_run(function(target)
    os.execv('lcov', {
      '-o', path.join(target:targetdir(), 'coverage.info'),
      '-c', '-d', target:objectdir()
    })
  end)
rule_end()
