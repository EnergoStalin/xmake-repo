package('qcustomplot')
  set_kind('library')
  set_homepage('https://www.qcustomplot.com/')
  set_description('Qt C++ widget for plotting and data visualization.')

  add_urls('https://www.qcustomplot.com/release/$(version)/QCustomPlot-source.tar.gz')

  add_versions('2.1.1', '5e2d22dec779db8f01f357cbdb25e54fbcf971adaee75eae8d7ad2444487182f')

  add_patches('2.1.1',
    'patches/2.1.1/qcustomplot.h.diff',
    'dcd8226f2787b51de8555c03b3ac9a3e3ba63066f52d31f955336d81ba5d3dfb'
  )

  add_configs('cxxver', {description = 'C++ standard to use for qt > 6 specify > 17', default = 17, type = 'number', readonly = false})

  on_install(function(package)
    io.writefile('xmake.lua', string.format([[
      add_rules('mode.debug', 'mode.release')
      set_languages('cxx%s')

      target('qcustomplot')
        set_kind('$(kind)')
        add_rules('qt.$(kind)')

        add_defines('QCUSTOMPLOT_COMPILE_LIBRARY')
        add_frameworks('QtPrintSupport')

        add_files(
          'qcustomplot.cpp',
          'qcustomplot.h'
        )
        
        add_headerfiles('qcustomplot.h', { public = true })
        add_includedirs('.', { public = true })
    ]], package:config('cxxver')))
    import('package.tools.xmake').install(package)
  end)
