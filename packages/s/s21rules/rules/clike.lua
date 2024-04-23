local function clike(target)
    target:set('warnings', 'allextra', 'error', 'pedantic')
    target:set('toolchains', 'gcc')
end

local function cxx(target)
     clike(target)
     target:set('languages', 'cxx17')
end

local function c(target)
    clike(target)
    target:set('languages', 'c11')
end

rule('cxxtest')
  add_deps('mode.coverage', 'mode.release', 'mode.debug')
  on_config(function(target)
    cxx(target)
    target:add('packages', 'gtest')

    if is_mode('coverage') then
      target:add('ldflags', '--coverage')
    end
  end)
rule_end()

rule('cxxlib')
  add_deps('mode.coverage', 'mode.release', 'mode.debug')
  on_config(function(target)
    cxx(target)
    if is_mode('coverage') then
      -- Somehow --coverage is not sufficient for generating .gcno files
      target:add("cxflags", "-fprofile-arcs -ftest-coverage")
      target:add("mxflags", "-fprofile-arcs -ftest-coverage")
      target:add("ldflags", "-fprofile-arcs -ftest-coverage")
      target:add("shflags", "-fprofile-arcs -ftest-coverage")
    end
  end)
rule_end()

rule('ctest')
  add_deps('mode.coverage', 'mode.release', 'mode.debug')
  on_config(function(target)
    c(target)
    target:add('packages', 'check')

    if is_mode('coverage') then
      target:add('ldflags', '--coverage')
    end
  end)
rule_end()

rule('clib')
  add_deps('mode.coverage', 'mode.release', 'mode.debug')
  on_config(function(target)
    c(target)
    if is_mode('coverage') then
      -- Somehow --coverage is not sufficient for generating .gcno files
      target:add("cxflags", "-fprofile-arcs -ftest-coverage")
      target:add("mxflags", "-fprofile-arcs -ftest-coverage")
      target:add("ldflags", "-fprofile-arcs -ftest-coverage")
      target:add("shflags", "-fprofile-arcs -ftest-coverage")
    end
  end)
rule_end()
