-- run target
local function _do_run_target(target, os, runenvs, debugger, option)
  -- only for binary program
  if not target:is_binary() then
    return
  end

  -- get the run directory of target
  local rundir = target:rundir()
  -- get the absolute target file path
  local targetfile = path.absolute(target:targetfile())
  -- get the run environments
  local addenvs, setenvs = runenvs.make(target)
  -- get run arguments
  local args = table.wrap(option.get("arguments") or target:get("runargs"))

  -- debugging?
  if option.get("debug") then
    debugger.run(targetfile, args, { curdir = rundir, addenvs = addenvs, setenvs = setenvs })
  else
    os.execv(targetfile, args, { curdir = rundir, detach = option.get("detach"), addenvs = addenvs, setenvs = setenvs })
  end
end

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

local function memcheck(target)
  import("private.action.run.runenvs")
  import("core.base.option")
  import("devel.debugger")

  if not is_mode('valgrind') then
    _do_run_target(target, os, runenvs, debugger, option)
    return
  end

  local targetfile = path.absolute(target:targetfile())

  os.execv('valgrind', {
    '--leak-check=full',
    '--show-leak-kinds=all',
    '--track-origins=yes',
    '--verbose',
    '--',
    targetfile
  })
end

rule('cxxtest')
  add_deps('mode.coverage', 'mode.release', 'mode.debug', 'mode.valgrind')
  on_run(memcheck)
  on_config(function(target)
    cxx(target)
    target:add('packages', 'gtest')
    target:set('group', 'test')

    if is_mode('debug') then
      target:add('cxxflags', '-Wno-unused-variable')
    end

    if is_mode('coverage') then
      target:add('ldflags', '--coverage')
    end
  end)
rule_end()

rule('cxxlib')
  add_deps('mode.coverage', 'mode.release', 'mode.debug')
  on_config(function(target)
    cxx(target)
    target:set('group', 'lib')

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
  add_deps('mode.coverage', 'mode.release', 'mode.debug', 'mode.valgrind')
  on_run(memcheck)
  on_config(function(target)
    c(target)
    target:add('packages', 'check')
    target:set('group', 'test')

    if is_mode('debug') then
      target:add('cflags', '-Wno-unused-variable')
    end

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

rule('c')
  add_deps('mode.release', 'mode.debug')
  on_config(c)
rule_end()

rule('cxx')
  add_deps('mode.release', 'mode.debug')
  on_config(cxx)
rule_end()
