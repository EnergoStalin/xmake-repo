rule('libreport')
  after_run(function(target)
    if not is_mode('coverage') then return end

    for k, v in pairs(target:deps()) do
      os.execv('lcov', {
        '-o', path.join(target:targetdir(), k .. '.info'),
        '-c', '-d', v:objectdir(),
      })
    end

    os.execv('sh', {
      '-c',
      string.format([[%s '%s' '%s']],
        [[genhtml --ignore-errors unused -exclude '/usr/*' -o]],
        path.join(os.projectdir(), 'report'),
        path.join(target:targetdir(), '*.info')
      )
    })
  end)
rule_end()

