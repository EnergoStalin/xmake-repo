rule('clike')
  add_deps('mode.release', 'mode.debug', 'mode.tsan', 'mode.asan')
  on_config(function(target)
    target:set('warnings', 'allextra', 'error', 'pedantic')
    target:set('toolchains', 'gcc')

    target:set('prefixname', 's21_')
  end)
rule_end()

rule('cxx')
  add_deps('clike')
  on_config(function(target)
    target:set('languages', 'cxx17')
  end)
rule_end()

rule('cxxtest')
  add_deps('cxx')
  on_config(function(target)
    target:add('packages', 'gtest')

    if is_mode('coverage') then
      target:add('ldflags', '--coverage')
    end
  end)
rule_end()

rule('cxxlib')
  add_deps('cxx', 'mode.coverage')
  on_config(function(target)
    if is_mode('coverage') then
      -- Somehow --coverage is not sufficient for generating .gcno files
      target:add("cxflags", "-fprofile-arcs -ftest-coverage")
      target:add("mxflags", "-fprofile-arcs -ftest-coverage")
      target:add("ldflags", "-fprofile-arcs -ftest-coverage")
      target:add("shflags", "-fprofile-arcs -ftest-coverage")
    end
  end)
rule_end()

rule('c')
  add_deps('clike')
  on_config(function(target)
    target:set('languages', 'c11')
  end)
rule_end()

rule('ctest')
  add_deps('c')
  on_config(function(target)
    target:add('packages', 'check')

    if is_mode('coverage') then
      target:add('ldflags', '--coverage')
    end
  end)
rule_end()

rule('clib')
  add_deps('c', 'mode.coverage')
  on_config(function(target)
    if is_mode('coverage') then
      -- Somehow --coverage is not sufficient for generating .gcno files
      target:add("cxflags", "-fprofile-arcs -ftest-coverage")
      target:add("mxflags", "-fprofile-arcs -ftest-coverage")
      target:add("ldflags", "-fprofile-arcs -ftest-coverage")
      target:add("shflags", "-fprofile-arcs -ftest-coverage")
    end
  end)
rule_end()
