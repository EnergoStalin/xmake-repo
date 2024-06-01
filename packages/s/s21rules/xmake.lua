set_xmakever("2.9.2")

package('s21rules')
  set_homepage("https://edu.21-school.ru/")
  set_description("xmake rules for convinient building according to school rules")

  on_install("windows", "macos", "linux", function () end)
