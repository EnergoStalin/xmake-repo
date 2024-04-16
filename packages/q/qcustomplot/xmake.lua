package('qcustomplot')
  set_homepage('https://www.qcustomplot.com/')
  set_description('Qt C++ widget for plotting and data visualization.')

  add_urls('https://www.qcustomplot.com/release/$(version)/QCustomPlot-source.tar.gz')

  add_versions('2.1.1', '5e2d22dec779db8f01f357cbdb25e54fbcf971adaee75eae8d7ad2444487182f')

  on_install(function(package)
    io.writefile('xmake.lua', [[
      add_rules('mode.debug', 'mode.release')
      set_languages('cxx17')
      target('qcustomplot')
        set_kind('static')
        add_files('qcustomplot-source/qcustomplot.cpp')
        add_headerfiles('qcustomplot-source/qcustomplot.h', { public = true })
        add_includedirs('qcustomplot-source', { public = true })
    ]])
    import('package.tools.xmake').install(package)
  end)
