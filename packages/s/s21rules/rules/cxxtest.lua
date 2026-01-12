local function _concat_args(a1, a2)
  for _, value in pairs(a2) do
    table.insert(a1, value)
  end
end

rule('cxxtest')
  add_deps('mode.coverage', 'mode.release', 'mode.debug', 'mode.valgrind')
  after_build(function (target)
    if not is_mode('valgrind') then return end

    import('core.base.option')

    local vargs = {}

    if option.get('verbose') then
      _concat_args(vargs, {
        '--leak-check=full',
        '--show-leak-kinds=all',
        '--track-origins=yes',
        '--verbose',
      })
    end

    _concat_args(vargs, { '--', path.join(os:projectdir(), target:targetfile()) })

    target:set('runargs', vargs)
    target.targetfile = function ()
      import('lib.detect.find_tool')
      return find_tool('valgrind').program
    end
  end)
  on_config(function(target)
    target:set('warnings', 'allextra', 'error', 'pedantic')
    target:set('toolchains', 'gcc')
    target:set('languages', 'cxx17')

    target:add('packages', 'gtest')

    if is_mode('debug') then
      target:add('cxxflags', '-Wno-unused-variable')
    end
  end)
rule_end()

