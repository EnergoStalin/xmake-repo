rule('cxx')
  add_deps('clike')
  on_config(function(target)
    target:set_languages('cxx17')
  end)
rule_end()