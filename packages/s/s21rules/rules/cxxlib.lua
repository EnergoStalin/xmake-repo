rule('cxxlib')
  add_deps('@s21rules/clib', '@s21rules/cxx')
  add_orders('@s21rules/clib', '@s21rules/cxx', '@s21rules/cxxlib')
rule_end()

