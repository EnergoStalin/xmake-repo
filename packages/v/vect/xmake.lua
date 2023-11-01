package("vect")
  set_urls("https://github.com/EnergoStalin/vect.git")

  on_install("windows", "macos", "linux", function (package) 
    import("package.tools.xmake").install(package)
  end)
