rule('clib')
  add_deps('@s21rules/c', 'mode.coverage')
  add_orders('@s21rules/c', '@s21rules/clib')
  on_config(function (target)
    if is_mode('coverage') then
      target:add("cxflags", "-fprofile-arcs -ftest-coverage")
      target:add("mxflags", "-fprofile-arcs -ftest-coverage")
      target:add("ldflags", "-fprofile-arcs -ftest-coverage")
      target:add("shflags", "-fprofile-arcs -ftest-coverage")
    end
  end)
rule_end()

