Run code:
  based on: hitchrunpy
  preconditions:
    code: |
      pyrunner.with_code((
          'with open("examplefile", "w") as handle:'
          '     handle.write("exampletext")'
      )).run()
  scenario:
  - Run code
  - File contains:
      filename: examplefile
      contents: exampletext


Long strings:
  based on: hitchrunpy
  preconditions:
    code: |
      long_string = u"â long string"

      pyrunner.with_code((
          'with open("examplefile", "w") as handle:'
          '     handle.write(long_string)'
      )).with_long_strings(long_string=long_string).run()
  scenario:
  - Run code
  - File contains:
      filename: examplefile
      contents: â long string


Error occurred:
  based on: hitchrunpy
  preconditions:
    code: |
      pyrunner.with_code('''x =''').run()
  scenario:
  - Raises exception:
      exception type: hitchrunpy.exceptions.ErrorRunningCode
      message: "Error running code. Output:\n\n  File \"examplepythoncode.py\", line\
        \ 50                                          \n    x =                  \
        \                                                       \n      ^        \
        \                                                                 \nSyntaxError:\
        \ invalid syntax"

Unexpected exception:
  based on: hitchrunpy
  preconditions:
    code: |
      pyrunner.with_code("""

      raise Exception('This should not hâppen')

      """).run()
  scenario:
  - Raises exception:
      exception type: hitchrunpy.exceptions.UnexpectedException
      message: "Unexpected exception 'builtins.Exception' raised. Stacktrace:\n\n\
        [0]: function '[[ BRIGHT ]]<module>[[ RESET ALL ]]'\n  examplepythoncode.py\n\
        \n    \n        56 : \n        57 : \n    --> [[ BRIGHT ]]58[[ RESET ALL ]]\
        \ : \n        59 : \n    \n    \n\n[1]: function '[[ BRIGHT ]]runcode[[ RESET\
        \ ALL ]]'\n  examplepythoncode.py\n\n    \n        49 :             \"lhs\"\
        : repr(lhs),\n        50 :             \"rhs\": repr(rhs),\n    --> [[ BRIGHT\
        \ ]]51[[ RESET ALL ]] :         }))\n        52 : \n    \n    \n\n[[ RED ]][[\
        \ BRIGHT ]]builtins.Exception[[ RESET ALL ]]\n  [[ DIM ]][[ RED ]]Common base\
        \ class for all non-exit exceptions.[[ RESET ALL ]]\n[[ RED ]]This should\
        \ not hâppen[[ RESET FORE ]]"

Setup code:
  based on: hitchrunpy
  preconditions:
    code: |
      pyrunner.with_code((
          'with open("examplefile", "w") as handle:'
          '     handle.write(exampletext)'
      )).with_setup_code("exampletext = 'exampletext'")\
        .run()
  scenario:
  - Run code
  - File contains:
      filename: examplefile
      contents: exampletext
