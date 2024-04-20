rule('libreport')
  after_run(function(target)
    if not is_mode('coverage') then return end

    for k, v in pairs(target._DEPS) do
      os.execv('lcov', {
        '-o', path.join(target:targetdir(), k .. '.info'),
        '-c', '-d', v:objectdir(),
      })
    end

    os.execv('sh', {
      '-c',
      'genhtml -exclude \'/usr/*\' -o '
      .. path.join(target._INFO._INTERPRETER:rootdir(), 'report')
      .. ' '
      .. path.join(target:targetdir(), '*.info')
    })
  end)
rule_end()

