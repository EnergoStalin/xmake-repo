# Homepage

- https://platform.21-school.ru/

# Example

## C

<details>
  <summary>Library</summary>

```lua
set_project('vect')

add_repositories('energostalin git@github.com:EnergoStalin/xmake-repo.git')

add_requires('s21rules')

target('vect')
  set_default()
  set_kind('$(kind)')
  add_files('vect.c')
  add_headerfiles('vect.h')

  add_rules('@s21rules/clib')
target_end()
```

</details>

<details>
  <summary>Binary</summary>

```lua
set_project('main')

add_repositories('energostalin git@github.com:EnergoStalin/xmake-repo.git')

add_requires('s21rules')

target('main')
  set_default()
  set_kind('binary')
  add_files('main.c')

  add_rules('@s21rules/c')
target_end()
```

</details>
<details>
  <summary>Test</summary>

Usually get imported from subdirectory therefore does not have own repository declaration.

```lua
set_project('vect-test')

add_requires('s21rules', 'check')

target('vect-test')
  set_kind('binary')
  set_group('test')

  add_files('*.c')
  add_deps('vect')

  add_rules('@s21rules/ctest')
target_end()
```

</details>

## C++

Same thing but `cxx` instead of `c`.
