rule('valgrind')
  if not is_mode('valgrind') then return end

  on_run(function(target)
    os.execv('valgrind', {
      '--trace-children=yes', '-s',
      '--leak-check=full', '--', target:targetfile(),
    })
  end)
rule_end()
