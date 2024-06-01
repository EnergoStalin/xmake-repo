local function _concat_args(a1, a2)
  for _, value in pairs(a2) do
    table.insert(a1, value)
  end
end

local function _on_run(target)
  if not target:is_binary() then
    return
  end

  import("private.action.run.runenvs")
  import("core.base.option")
  import("devel.debugger")

  local rundir = target:rundir()
  local targetfile = path.absolute(target:targetfile())
  local addenvs, setenvs = runenvs.make(target)
  local args = table.wrap(option.get("arguments") or target:get("runargs"))

  local exec = {
    curdir = rundir,
    addenvs = addenvs,
    setenvs = setenvs
  }

  if option.get('detach') then
    exec.detach = option.get('detach')
  end

  if not is_mode('valgrind') then
    if option.get('debug') then
      debugger.run(targetfile, args, exec)
    else
      os.execv(targetfile, vargs, exec)
    end
    return
  end

  local vargs = {}

  if option.get('verbose') then
    _concat_args(vargs, {
      '--leak-check=full',
      '--show-leak-kinds=all',
      '--track-origins=yes',
      '--verbose',
    })
  end

  _concat_args(vargs, { '--', targetfile })
  _concat_args(vargs, args)

  os.execv('valgrind', vargs, exec)
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


rule('cxxtest')
  add_deps('mode.coverage', 'mode.release', 'mode.debug', 'mode.valgrind')
  on_run(_on_run)
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
  on_run(_on_run)
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
