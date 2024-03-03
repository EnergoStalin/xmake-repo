rule('coverage')
  if not is_mode('coverage') then return end

  on_config(function(target)
    target:add_links('gcov')
    target:add_cxflags('-fprofile-arcs', '-ftest-coverage')
  end)
rule_end()
