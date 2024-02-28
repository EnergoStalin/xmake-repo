rule('coverage')
  if not is_mode('coverage') then return end

  on_load(function(target)
    target:add('links', 'gcov')
  end)

  on_config(function(target)
    target:add('cxflags', table.unpack({ '-fprofile-arcs', '-ftest-coverage', }))
  end)
rule_end()

rule('lib/report')
  if not is_mode('coverage') then return end

  after_run(function(target)
    for k, v in pairs(target._DEPS) do
      os.execv('lcov', { '-o', path.join(target:targetdir(), k .. '.info'), '-c', '-d', v:objectdir(), })
    end
  end)
rule_end()

rule('report')
  if not is_mode('coverage') then return end

  after_run(function(target)
    os.execv("lcov", { "-o", path.join(target:targetdir(), "coverage.info"), "-c", "-d", target:objectdir() })
  end)
rule_end()

rule('valgrind')
  if not is_mode('valgrind') then return end

  on_run(function(target)
    os.execv('valgrind', { '--trace-children=yes', '-s', '--leak-check=full', '--', target:targetfile(), })
  end)
rule_end()
