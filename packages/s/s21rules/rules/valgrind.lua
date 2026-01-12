local function _concat_args(a1, a2)
  for _, value in pairs(a2) do
    table.insert(a1, value)
  end
end

rule('valgrind')
  add_deps('mode.valgrind')
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
rule_end()

