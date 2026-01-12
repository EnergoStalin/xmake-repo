rule('cxxtest')
  add_deps('@s21rules/cxx', '@s21rules/test')
  add_orders('@s21rules/cxx', '@s21rules/test', '@s21rules/cxxtest')
  on_config(function (target)
    target:add('packages', 'gtest')
  end)
rule_end()

