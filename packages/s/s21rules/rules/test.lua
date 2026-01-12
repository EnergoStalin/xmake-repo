rule('test')
  add_deps('@s21rules/valgrind', 'mode.coverage')
  add_orders('@s21rules/valgrind', '@s21rules/test')
  on_config(function (target)
    if is_mode('debug') then
      target:add('cflags', '-Wno-unused-variable')
    end

    if is_mode('coverage') then
      target:add('ldflags', '--coverage')
    end
  end)
rule_end()

