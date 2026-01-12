rule('ctest')
  add_deps('@s21rules/c', '@s21rules/test')
  add_orders('@s21rules/c', '@s21rules/test', '@s21rules/ctest')
  on_config(function(target)
    target:add('packages', 'check')
  end)
rule_end()

