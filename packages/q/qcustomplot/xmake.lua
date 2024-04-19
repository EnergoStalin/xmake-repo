package('qcustomplot')
  set_homepage('https://www.qcustomplot.com/')
  set_description('Qt C++ widget for plotting and data visualization.')

  add_urls('https://www.qcustomplot.com/release/$(version)/QCustomPlot-source.tar.gz')

  add_versions('2.1.1', '5e2d22dec779db8f01f357cbdb25e54fbcf971adaee75eae8d7ad2444487182f')

  on_install(function(package)
    io.writefile('xmake.lua', [[
      set_languages('cxx11')

      add_requires('qt5base', 'qt5gui')

      target('qcustomplot')
        set_kind('shared')
        add_rules('qt.shared')

        add_defines('QCUSTOMPLOT_COMPILE_LIBRARY')
        add_frameworks('QtPrintSupport')
        add_packages('qt5base', 'qt5gui')

        add_files(
          'qcustomplot.cpp',
          'qcustomplot.h'
        )
        
        add_headerfiles('qcustomplot.h', { public = true })
        add_includedirs('.', { public = true })
    ]])
    import('package.tools.xmake').install(package)
  end)
