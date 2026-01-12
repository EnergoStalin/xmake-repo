package('check')
  set_kind('library')
  set_homepage('https://libcheck.github.io/')
  set_description('A unit testing framework for C')

  add_urls('git@github.com:libcheck/check.git')

  add_extsources('pacman::check')

  on_install('linux', function(package)
    local configs = {}
    table.insert(configs, '--enable-shared=' .. (package:config('shared') and 'yes' or 'no'))
    table.insert(configs, '--enable-static=' .. (package:config('shared') and 'no' or 'yes'))
    if package:debug() then
        table.insert(configs, '--enable-debug')
    end
    table.insert(configs, 'CFLAGS=-g -O0')
    table.insert(configs, '--disable-build-docs')
    import('package.tools.autoconf').install(package, configs)
  end)
