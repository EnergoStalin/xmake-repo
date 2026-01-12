rule('cxxlib')
  add_deps('mode.coverage', 'mode.release', 'mode.debug')
  on_config(function(target)
    target:set('warnings', 'allextra', 'error', 'pedantic')
    target:set('toolchains', 'gcc')
    target:set('languages', 'cxx17')

    if is_mode('coverage') then
      target:add("cxflags", "-fprofile-arcs -ftest-coverage")
      target:add("mxflags", "-fprofile-arcs -ftest-coverage")
      target:add("ldflags", "-fprofile-arcs -ftest-coverage")
      target:add("shflags", "-fprofile-arcs -ftest-coverage")
    end
  end)
rule_end()

